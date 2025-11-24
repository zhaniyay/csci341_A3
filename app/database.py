# app/database.py
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DEFAULT_DB_URL = "postgresql://caregivers_user:strongpassword@localhost:5432/caregivers_db"

DATABASE_URL = os.getenv("DATABASE_URL", DEFAULT_DB_URL)

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
