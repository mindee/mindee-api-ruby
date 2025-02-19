---
title: Ruby Client Library - Resume
category: 622b805aaec68102ea7fcbc2
slug: ruby-resume-ocr
parentDoc: 67b49df15b843f3fa9cd622b
---
The Ruby Client Library SDK supports the [Resume API](https://platform.mindee.com/mindee/resume).


> 📝 Product Specs
>
> | Specification                  | Details                                            |
> | ------------------------------ | -------------------------------------------------- |
> | Endpoint                       | `resume`                                           |
> | Recommended Version            | `v1.2`                                             |
> | Supports Polling/Webhooks      | ✔️ Yes                                             |
> | Support Synchronous HTTP Calls | ❌ No                                              |
> | Geography                      | 🌐 Global                                          |

> 🔐 Polling Limitations
>
> | Setting                         | Parameter name          | Value       |
> | ------------------------------- | ----------------------- | ----------- |
> | Initial Delay Before Polling    | `initial_delay_seconds` | 2 seconds   |
> | Default Delay Between Calls     | `delay_sec`             | 1.5 seconds |
> | Polling Attempts Before Timeout | `max_retries`           | 80 retries  |


Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/resume/default_sample.jpg), we are going to illustrate how to extract the data that we want using the
Ruby Client Library.
![Resume sample](https://github.com/mindee/client-lib-test-data/blob/main/products/resume/default_sample.jpg?raw=true)

# Quick-Start
```rb
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
result = mindee_client.parse(
  input_source,
  Mindee::Product::Resume::ResumeV1
)

# Print a full summary of the parsed data in RST format
puts result.document

# Print the document-level parsed data
# puts result.document.inference.prediction
```

**Output (RST):**
```rst
########
Document
########
:Mindee ID: 9daa3085-152c-454e-9245-636f13fc9dc3
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/resume v1.1
:Rotation applied: Yes

Prediction
==========
:Document Language: ENG
:Document Type: RESUME
:Given Names: Christopher
:Surnames: Morgan
:Nationality:
:Email Address: christoper.m@gmail.com
:Phone Number: +44 (0)20 7666 8555
:Address: 177 Great Portland Street, London, W5W 6PQ
:Social Networks:
  +----------------------+----------------------------------------------------+
  | Name                 | URL                                                |
  +======================+====================================================+
  | LinkedIn             | linkedin.com/christopher.morgan                    |
  +----------------------+----------------------------------------------------+
:Profession: Senior Web Developer
:Job Applied:
:Languages:
  +----------+----------------------+
  | Language | Level                |
  +==========+======================+
  | SPA      | Fluent               |
  +----------+----------------------+
  | ZHO      | Beginner             |
  +----------+----------------------+
  | DEU      | Beginner             |
  +----------+----------------------+
:Hard Skills: HTML5
              PHP OOP
              JavaScript
              CSS
              MySQL
              SQL
:Soft Skills: Project management
              Creative design
              Strong decision maker
              Innovative
              Complex problem solver
              Service-focused
:Education:
  +-----------------+---------------------------+-----------+----------+---------------------------+-------------+------------+
  | Domain          | Degree                    | End Month | End Year | School                    | Start Month | Start Year |
  +=================+===========================+===========+==========+===========================+=============+============+
  | Computer Inf... | Bachelor                  |           | 2014     | Columbia University, NY   |             |            |
  +-----------------+---------------------------+-----------+----------+---------------------------+-------------+------------+
:Professional Experiences:
  +-----------------+------------+--------------------------------------+---------------------------+-----------+----------+----------------------+-------------+------------+
  | Contract Type   | Department | Description                          | Employer                  | End Month | End Year | Role                 | Start Month | Start Year |
  +=================+============+======================================+===========================+===========+==========+======================+=============+============+
  |                 |            | Cooperate with designers to creat... | Luna Web Design, New York | 05        | 2019     | Web Developer        | 09          | 2015       |
  +-----------------+------------+--------------------------------------+---------------------------+-----------+----------+----------------------+-------------+------------+
:Certificates:
  +------------+--------------------------------+---------------------------+------+
  | Grade      | Name                           | Provider                  | Year |
  +============+================================+===========================+======+
  |            | PHP Framework (certificate)... |                           |      |
  +------------+--------------------------------+---------------------------+------+
```

# Field Types
## Standard Fields
These fields are generic and used in several products.

### Basic Field
Each prediction object contains a set of fields that inherit from the generic `Field` class.
A typical `Field` object will have the following attributes:

* **value** (`String`, `Float`, `Integer`, `bool`): corresponds to the field value. Can be `nil` if no value was extracted.
* **confidence** (Float, nil): the confidence score of the field prediction.
* **bounding_box** (`Mindee::Geometry::Quadrilateral`, `nil`): contains exactly 4 relative vertices (points) coordinates of a right rectangle containing the field in the document.
* **polygon** (`Mindee::Geometry::Polygon`, `nil`): contains the relative vertices coordinates (`Point`) of a polygon containing the field in the image.
* **page_id** (`Integer`, `nil`): the ID of the page, always `nil` when at document-level.
* **reconstructed** (`bool`): indicates whether an object was reconstructed (not extracted as the API gave it).


Aside from the previous attributes, all basic fields have access to a `to_s` method that can be used to print their value as a string.


### Classification Field
The classification field `ClassificationField` does not implement all the basic `Field` attributes. It only implements
**value**, **confidence** and **page_id**.

> Note: a classification field's `value is always a `String`.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Social Networks Field
The list of social network profiles of the candidate.

A `ResumeV1SocialNetworksUrl` implements the following attributes:
      
* `name` (String): The name of the social network.
* `url` (String): The URL of the social network.
Fields which are specific to this product; they are not used in any other product.

### Languages Field
The list of languages that the candidate is proficient in.

A `ResumeV1Language` implements the following attributes:
      
* `language` (String): The language's ISO 639 code.
* `level` (String): The candidate's level for the language.

#### Possible values include:
 - Native
 - Fluent
 - Proficient
 - Intermediate
 - Beginner
        
Fields which are specific to this product; they are not used in any other product.

### Education Field
The list of the candidate's educational background.

A `ResumeV1Education` implements the following attributes:
      
* `degree_domain` (String): The area of study or specialization.
* `degree_type` (String): The type of degree obtained, such as Bachelor's, Master's, or Doctorate.
* `end_month` (String): The month when the education program or course was completed.
* `end_year` (String): The year when the education program or course was completed.
* `school` (String): The name of the school.
* `start_month` (String): The month when the education program or course began.
* `start_year` (String): The year when the education program or course began.
Fields which are specific to this product; they are not used in any other product.

### Professional Experiences Field
The list of the candidate's professional experiences.

A `ResumeV1ProfessionalExperience` implements the following attributes:
      
* `contract_type` (String): The type of contract for the professional experience.

#### Possible values include:
 - Full-Time
 - Part-Time
 - Internship
 - Freelance
        
* `department` (String): The specific department or division within the company.
* `description` (String): The description of the professional experience as written in the document.
* `employer` (String): The name of the company or organization.
* `end_month` (String): The month when the professional experience ended.
* `end_year` (String): The year when the professional experience ended.
* `role` (String): The position or job title held by the candidate.
* `start_month` (String): The month when the professional experience began.
* `start_year` (String): The year when the professional experience began.
Fields which are specific to this product; they are not used in any other product.

### Certificates Field
The list of certificates obtained by the candidate.

A `ResumeV1Certificate` implements the following attributes:
      
* `grade` (String): The grade obtained for the certificate.
* `name` (String): The name of certification.
* `provider` (String): The organization or institution that issued the certificate.
* `year` (String): The year when a certificate was issued or received.

# Attributes
The following fields are extracted for Resume V1:

## Address
**address** ([StringField](#string-field)): The location information of the candidate, including city, state, and country.

```rb
puts result.document.inference.prediction.address.value
```

## Certificates
**certificates** (Array<[ResumeV1Certificate](#certificates-field)>): The list of certificates obtained by the candidate.

```rb
result.document.inference.prediction.certificates do |certificates_elem|
  puts certificates_elem.value
end
```

## Document Language
**document_language** ([StringField](#string-field)): The ISO 639 code of the language in which the document is written.

```rb
puts result.document.inference.prediction.document_language.value
```

## Document Type
**document_type** ([ClassificationField](#classification-field)): The type of the document sent.

#### Possible values include:
 - RESUME
 - MOTIVATION_LETTER
 - RECOMMENDATION_LETTER

```rb
puts result.document.inference.prediction.document_type.value
```

## Education
**education** (Array<[ResumeV1Education](#education-field)>): The list of the candidate's educational background.

```rb
result.document.inference.prediction.education do |education_elem|
  puts education_elem.value
end
```

## Email Address
**email_address** ([StringField](#string-field)): The email address of the candidate.

```rb
puts result.document.inference.prediction.email_address.value
```

## Given Names
**given_names** (Array<[StringField](#string-field)>): The candidate's first or given names.

```rb
result.document.inference.prediction.given_names do |given_names_elem|
  puts given_names_elem.value
end
```

## Hard Skills
**hard_skills** (Array<[StringField](#string-field)>): The list of the candidate's technical abilities and knowledge.

```rb
result.document.inference.prediction.hard_skills do |hard_skills_elem|
  puts hard_skills_elem.value
end
```

## Job Applied
**job_applied** ([StringField](#string-field)): The position that the candidate is applying for.

```rb
puts result.document.inference.prediction.job_applied.value
```

## Languages
**languages** (Array<[ResumeV1Language](#languages-field)>): The list of languages that the candidate is proficient in.

```rb
result.document.inference.prediction.languages do |languages_elem|
  puts languages_elem.value
end
```

## Nationality
**nationality** ([StringField](#string-field)): The ISO 3166 code for the country of citizenship of the candidate.

```rb
puts result.document.inference.prediction.nationality.value
```

## Phone Number
**phone_number** ([StringField](#string-field)): The phone number of the candidate.

```rb
puts result.document.inference.prediction.phone_number.value
```

## Profession
**profession** ([StringField](#string-field)): The candidate's current profession.

```rb
puts result.document.inference.prediction.profession.value
```

## Professional Experiences
**professional_experiences** (Array<[ResumeV1ProfessionalExperience](#professional-experiences-field)>): The list of the candidate's professional experiences.

```rb
result.document.inference.prediction.professional_experiences do |professional_experiences_elem|
  puts professional_experiences_elem.value
end
```

## Social Networks
**social_networks_urls** (Array<[ResumeV1SocialNetworksUrl](#social-networks-field)>): The list of social network profiles of the candidate.

```rb
result.document.inference.prediction.social_networks_urls do |social_networks_urls_elem|
  puts social_networks_urls_elem.value
end
```

## Soft Skills
**soft_skills** (Array<[StringField](#string-field)>): The list of the candidate's interpersonal and communication abilities.

```rb
result.document.inference.prediction.soft_skills do |soft_skills_elem|
  puts soft_skills_elem.value
end
```

## Surnames
**surnames** (Array<[StringField](#string-field)>): The candidate's last names.

```rb
result.document.inference.prediction.surnames do |surnames_elem|
  puts surnames_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-2d0ds7dtz-DPAF81ZqTy20chsYpQBW5g)
