import logging
from fastapi import FastAPI, HTTPException

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger(__name__)

app = FastAPI(title="DevOps Skill-UP API")

@app.get("/health")
def health_check():
    logger.info("Health check endpoint hit")
    return {"status": "healthy", "version":"1.0.0"}

@app.get("/stimulate-error")
def stimulate_error():
    logger.error("CRITICAL: Database connection pool exhausted. Timeout after 3000ms.")
    raise HTTPException(status_code=500, detail="Internal Server Error: DB Connection Failed")