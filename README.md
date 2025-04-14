# Rill Data Project Guide for Junior Developers

This guide walks you through setting up and understanding the components of this Rill Data project, from getting the data to exploring it and sharing it via APIs.

## Objective

To analyze session data using Rill Data, building models, dashboards, and APIs based on data stored in MotherDuck.

## 1. Get the Source Data

* **Importance:** You need source data before you can build anything in Rill.
* **Action:** Follow the instructions in the data preparation repository to load the necessary data into your MotherDuck account:
    * [thedatagata/rill_demo_data_prep](https://github.com/thedatagata/rill_demo_data_prep)
* **Key Info Needed Later:** Note your MotherDuck database name and the table name (e.g., `md_src_session_fct`).

## 2. Connect Rill to Your Data (Source)

* **Purpose:** Tell Rill where to find your data in MotherDuck.
* **How:** Create a `.yaml` file in the `sources/` directory (e.g., `sources/motherduck_source.yaml`).
* **Example Structure:**
    ```yaml
    # sources/motherduck_source.yaml
    type: motherduck
    database: "<your-motherduck-db-name>.db" # Path to your MotherDuck DB
    # Rill typically uses RILL_MOTHERDUCK_TOKEN environment variable for auth
    ```
* **Note:** Rill needs your MotherDuck token. Set the `RILL_MOTHERDUCK_TOKEN` environment variable before running Rill commands.

## 3. Define Data Transformations (Model)

* **Purpose:** Clean, transform, and enrich your raw source data using SQL.
* **How:** Create `.sql` files in the `models/` directory. Each file typically defines one logical dataset or transformation.
* **Example (`models/rfm.sql`):** This project includes an RFM (Recency, Frequency, Monetary) analysis model. It takes the session data and calculates user segments based on their activity. It expects a source named `md_source_session_facts` (you might need to adjust this name based on your source file).

## 4. Define Key Business Metrics (Metrics View)

* **Purpose:** Define the dimensions (categories to slice by) and measures (calculations like SUM, AVG) you want to analyze. This powers the dashboards.
* **How:** Create a `.yaml` file (often named after the model, e.g., `session_metrics.yaml`) in the project root or `metrics_views/` directory.
* **Key Parts:**
    * `type: metrics_view`
    * `model:` (The name of the model file, e.g., `md_source_session_facts`)
    * `timeseries:` (The main timestamp column, e.g., `session_start_time`)
    * `dimensions:` (List of columns to group/filter by, e.g., browser, OS, country)
    * `measures:` (List of calculations, e.g., `SUM(pageviews)`, `AVG(revenue)`)

## 5. Create Interactive Dashboards (Explore)

* **Purpose:** Build interactive dashboards for visual data exploration.
* **How:** Create `.yaml` files in the `dashboards/` directory.
* **Example (`dashboards/session_metrics_explore.yaml`):**
    ```yaml
    type: explore # Tells Rill it's an Explore dashboard
    display_name: "Session Metrics Dashboard" # Name shown in UI
    metrics_view: session_metrics # Links to the metrics view defined earlier
    dimensions: '*' # Include all dimensions from the metrics view
    measures: '*' # Include all measures
    ```

## 6. Expose Data via API (Optional)

* **Purpose:** Share results of a specific SQL query programmatically.
* **How:** Create `.yaml` files in the `apis/` directory.
* **Example (`apis/rfm_api.yaml`):**
    ```yaml
    type: api
    sql: select * from rfm # Exposes the results of the 'rfm' model
    ```
* **Testing Locally:** Access at `http://localhost:9009/v1/instances/default/api/<api_filename>` (e.g., `rfm_api`).

## 7. Running & Deploying

* **Local Development:** Navigate to your project directory in the terminal and run:
    ```bash
    rill start
    ```
    This starts the local Rill UI where you can see your sources, models, dashboards, and test APIs.
* **Deployment:** To share your project, you'll typically deploy it to Rill Cloud. Follow the official Rill Data documentation for deployment instructions:
    * [Rill Deploy Docs](https://docs.rilldata.com/deploy)

This structure provides a clear path from raw data to interactive dashboards and APIs within your Rill project. Remember to consult the official [Rill Data Documentation](https://docs.rilldata.com/) for more in-depth details.