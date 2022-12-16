from pydantic import BaseModel
import datetime


class Model(BaseModel):
    class Config:
        underscore_attrs_are_private = True
        orm_mode = True
        error_msg_templates = {
            "value_error.any_str.min_length": "The minimum length is {limit_value} character(s).",
            "value_error.email": "Invalid email",
            "value_error.missing": "This field is required",
        }

        json_encoders = {
            datetime.datetime: lambda v: v.replace(tzinfo=datetime.timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%S%z") if v.tzinfo is None else v.strftime("%Y-%m-%dT%H:%M:%S%z"),
        }
