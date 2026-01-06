"""
Airflow DAG to trigger Databricks Serverless Job
Census ETL: Bronze → Silver → Gold
"""

import logging
from airflow import DAG
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

# -------------------------------------------------
# Logger
# -------------------------------------------------
logger = logging.getLogger(__name__)

# -------------------------------------------------
# Logging / Validation functions
# -------------------------------------------------
def validate_inputs(**context):
    logger.info("✅ Validating source census files...")
    # You can add file existence / row count checks here
    return True

def check_outputs(**context):
    logger.info("✅ Validating Gold layer outputs...")
    # You can add record count / null checks here
    return {"status": "success"}

def on_failure(context):
    logger.error(f"❌ Task failed: {context['task_instance'].task_id}")

def on_success(context):
    logger.info(
        f"✅ Pipeline completed in {context['task_instance'].duration}s"
    )

# -------------------------------------------------
# Default args
# -------------------------------------------------
default_args = {
    "owner": "sreejith",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
    "on_failure_callback": on_failure,
}

# -------------------------------------------------
# DAG
# -------------------------------------------------
with DAG(
    dag_id="census_databricks_etl",
    description="Census ETL Pipeline: Bronze → Silver → Gold",
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["census", "databricks", "delta", "capstone"],
) as dag:

    # ---------------------------------------------
    # Input validation task
    # ---------------------------------------------
    validate_task = PythonOperator(
        task_id="validate_inputs",
        python_callable=validate_inputs,
    )

    # ---------------------------------------------
    # Databricks ETL Job
    # ---------------------------------------------
    run_databricks_job = DatabricksRunNowOperator(
        task_id="run_databricks_etl",
        databricks_conn_id="databricks_default",
        job_id=69238265475804,  # your Databricks job id
        on_success_callback=on_success,
    )

    # ---------------------------------------------
    # Output validation task
    # ---------------------------------------------
    validate_outputs_task = PythonOperator(
        task_id="check_outputs",
        python_callable=check_outputs,
    )

    # ---------------------------------------------
    # Task order
    # ---------------------------------------------
    validate_task >> run_databricks_job >> validate_outputs_task
