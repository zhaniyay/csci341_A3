from typing import Optional
from datetime import date, time
from pydantic import BaseModel, EmailStr

class UserBase(BaseModel):
    email: EmailStr
    given_name: str
    surname: str
    city: Optional[str] = None
    phone_number: Optional[str] = None
    profile_description: Optional[str] = None


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    given_name: Optional[str] = None
    surname: Optional[str] = None
    city: Optional[str] = None
    phone_number: Optional[str] = None
    profile_description: Optional[str] = None
    password: Optional[str] = None


class UserOut(UserBase):
    user_id: int

    class Config:
        orm_mode = True


class CaregiverBase(BaseModel):
    caregiving_type: str
    hourly_rate: float
    photo: Optional[str] = None
    gender: Optional[str] = None


class CaregiverCreate(CaregiverBase):
    caregiver_user_id: int


class CaregiverOut(CaregiverBase):
    caregiver_user_id: int

    class Config:
        orm_mode = True


class MemberBase(BaseModel):
    house_rules: Optional[str] = None
    dependent_description: Optional[str] = None


class MemberCreate(MemberBase):
    member_user_id: int


class MemberOut(MemberBase):
    member_user_id: int

    class Config:
        orm_mode = True



class AddressBase(BaseModel):
    member_user_id: int
    house_number: str
    street: str
    town: str


class AddressCreate(AddressBase):
    pass


class AddressOut(AddressBase):
    class Config:
        orm_mode = True



class JobBase(BaseModel):
    member_user_id: int
    required_caregiving_type: str
    other_requirements: Optional[str] = None
    date_posted: date


class JobCreate(JobBase):
    pass


class JobOut(JobBase):
    job_id: int

    class Config:
        orm_mode = True



class JobApplicationBase(BaseModel):
    caregiver_user_id: int
    job_id: int
    date_applied: date


class JobApplicationCreate(JobApplicationBase):
    pass


class JobApplicationOut(JobApplicationBase):
    class Config:
        orm_mode = True



class AppointmentBase(BaseModel):
    caregiver_user_id: int
    member_user_id: int
    appointment_date: date
    appointment_time: time
    work_hours: int
    status: str


class AppointmentCreate(AppointmentBase):
    pass


class AppointmentOut(AppointmentBase):
    appointment_id: int

    class Config:
        orm_mode = True
