# app/models.py

from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    Numeric,
    Date,
    Time,
    ForeignKey,
)
from sqlalchemy.orm import relationship

from .database import Base


class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    given_name = Column(String(100), nullable=False)
    surname = Column(String(100), nullable=False)
    city = Column(String(100))
    phone_number = Column(String(20))
    profile_description = Column(Text)
    password = Column(String(255), nullable=False)

    caregiver = relationship("Caregiver", back_populates="user", uselist=False)
    member = relationship("Member", back_populates="user", uselist=False)


class Caregiver(Base):
    __tablename__ = "caregiver"

    caregiver_user_id = Column(
        Integer,
        ForeignKey("users.user_id", ondelete="CASCADE"),
        primary_key=True,
    )
    photo = Column(Text)
    gender = Column(String(50))
    caregiving_type = Column(String(50))
    hourly_rate = Column(Numeric(10, 2))

    user = relationship("User", back_populates="caregiver")
    appointments = relationship("Appointment", back_populates="caregiver")
    job_applications = relationship("JobApplication", back_populates="caregiver")



class Member(Base):
    __tablename__ = "member"

    member_user_id = Column(
        Integer,
        ForeignKey("users.user_id", ondelete="CASCADE"),
        primary_key=True,
    )
    house_rules = Column(Text)
    dependent_description = Column(Text)

    user = relationship("User", back_populates="member")
    address = relationship("Address", back_populates="member", uselist=False)
    jobs = relationship("Job", back_populates="member")
    appointments = relationship("Appointment", back_populates="member")


class Address(Base):
    __tablename__ = "address"

    member_user_id = Column(
        Integer,
        ForeignKey("member.member_user_id", ondelete="CASCADE"),
        primary_key=True,
    )
    house_number = Column(String(10))
    street = Column(String(255))
    town = Column(String(255))

    member = relationship("Member", back_populates="address")


class Job(Base):
    __tablename__ = "job"

    job_id = Column(Integer, primary_key=True, index=True)
    member_user_id = Column(
        Integer,
        ForeignKey("member.member_user_id", ondelete="CASCADE"),
    )
    required_caregiving_type = Column(String(50))
    other_requirements = Column(Text)
    date_posted = Column(Date)

    member = relationship("Member", back_populates="jobs")
    job_applications = relationship("JobApplication", back_populates="job")


class JobApplication(Base):
    __tablename__ = "job_application"

    caregiver_user_id = Column(
        Integer,
        ForeignKey("caregiver.caregiver_user_id", ondelete="CASCADE"),
        primary_key=True,
    )
    job_id = Column(
        Integer,
        ForeignKey("job.job_id", ondelete="CASCADE"),
        primary_key=True,
    )
    date_applied = Column(Date)

    caregiver = relationship("Caregiver", back_populates="job_applications")
    job = relationship("Job", back_populates="job_applications")

class Appointment(Base):
    __tablename__ = "appointment"

    appointment_id = Column(Integer, primary_key=True, index=True)
    caregiver_user_id = Column(
        Integer,
        ForeignKey("caregiver.caregiver_user_id", ondelete="CASCADE"),
    )
    member_user_id = Column(
        Integer,
        ForeignKey("member.member_user_id", ondelete="CASCADE"),
    )
    appointment_date = Column(Date)
    appointment_time = Column(Time)
    work_hours = Column(Integer)
    status = Column(String(50))

    caregiver = relationship("Caregiver", back_populates="appointments")
    member = relationship("Member", back_populates="appointments")
