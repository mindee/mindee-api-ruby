---
title: Resume OCR Ruby
---
The Ruby OCR SDK supports the [Resume API](https://platform.mindee.com/mindee/resume).

Using the [sample below](https://github.com/mindee/client-lib-test-data/blob/main/products/resume/default_sample.jpg), we are going to illustrate how to extract the data that we want using the OCR SDK.
![Resume sample](https://github.com/mindee/client-lib-test-data/blob/main/products/resume/default_sample.jpg?raw=true)

# Quick-Start
```rb
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

# Parse the file
result = mindee_client.enqueue_and_parse(
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
:Mindee ID: bc80bae0-af75-4464-95a9-2419403c75bf
:Filename: default_sample.jpg

Inference
#########
:Product: mindee/resume v1.0
:Rotation applied: No

Prediction
==========
:Document Language: ENG
:Document Type: RESUME
:Given Names: Christopher
:Surnames: Morgan
:Nationality:
:Email Address: christoper.m@gmail.com
:Phone Number: +44 (0) 20 7666 8555
:Address: 177 Great Portland Street, London W5W 6PQ
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
  | DEU      | Intermediate         |
  +----------+----------------------+
:Hard Skills: HTML5
              PHP OOP
              JavaScript
              CSS
              MySQL
:Soft Skills: Project management
              Strong decision maker
              Innovative
              Complex problem solver
              Creative design
              Service-focused
:Education:
  +-----------------+---------------------------+-----------+----------+---------------------------+-------------+------------+
  | Domain          | Degree                    | End Month | End Year | School                    | Start Month | Start Year |
  +=================+===========================+===========+==========+===========================+=============+============+
  | Computer Inf... | Bachelor                  |           |          | Columbia University, NY   |             | 2014       |
  +-----------------+---------------------------+-----------+----------+---------------------------+-------------+------------+
:Professional Experiences:
  +-----------------+------------+---------------------------+-----------+----------+----------------------+-------------+------------+
  | Contract Type   | Department | Employer                  | End Month | End Year | Role                 | Start Month | Start Year |
  +=================+============+===========================+===========+==========+======================+=============+============+
  | Full-Time       |            | Luna Web Design, New Y... | 05        | 2019     | Web Developer        | 09          | 2015       |
  +-----------------+------------+---------------------------+-----------+----------+----------------------+-------------+------------+
:Certificates:
  +------------+--------------------------------+---------------------------+------+
  | Grade      | Name                           | Provider                  | Year |
  +============+================================+===========================+======+
  |            | PHP Framework (certificate)... |                           | 2014 |
  +------------+--------------------------------+---------------------------+------+
  |            | Programming Languages: Java... |                           |      |
  +------------+--------------------------------+---------------------------+------+
```

# Field Types
## Standard Fields
These fields are generic and used in several products.

### Basic Field
Each prediction object contains a set of fields that inherit from the generic `Field` class.
A typical `Field` object will have the following attributes:

* **value** (`String`, `Float`, `Integer`, `Boolean`): corresponds to the field value. Can be `nil` if no value was extracted.
* **confidence** (Float, nil): the confidence score of the field prediction.
* **bounding_box** (`Mindee::Geometry::Quadrilateral`, `nil`): contains exactly 4 relative vertices (points) coordinates of a right rectangle containing the field in the document.
* **polygon** (`Mindee::Geometry::Polygon`, `nil`): contains the relative vertices coordinates (`Point`) of a polygon containing the field in the image.
* **page_id** (`Integer`, `nil`): the ID of the page, is `nil` when at document-level.
* **reconstructed** (`Boolean`): indicates whether an object was reconstructed (not extracted as the API gave it).


Aside from the previous attributes, all basic fields have access to a `to_s` method that can be used to print their value as a string.

### String Field
The text field `StringField` only has one constraint: it's **value** is a `String` (or `nil`).

## Specific Fields
Fields which are specific to this product; they are not used in any other product.

### Certificates Field
The list of certificates obtained by the candidate.

A `ResumeV1Certificate` implements the following attributes:

* `grade` (String): The grade obtained for the certificate.
* `name` (String): The name of certifications obtained by the individual.
* `provider` (String): The organization or institution that issued the certificates listed in the document.
* `year` (String): The year when a certificate was issued or received.
Fields which are specific to this product; they are not used in any other product.

### Education Field
The list of values that represent the educational background of an individual.

A `ResumeV1Education` implements the following attributes:

* `degree_domain` (String): The area of study or specialization pursued by an individual in their educational background.
* `degree_type` (String): The type of degree obtained by the individual, such as Bachelor's, Master's, or Doctorate.
* `end_month` (String): The month when the education program or course was completed or is expected to be completed.
* `end_year` (String): The year when the education program or course was completed or is expected to be completed.
* `school` (String): The name of the school the individual went to.
* `start_month` (String): The month when the education program or course began.
* `start_year` (String): The year when the education program or course began.
Fields which are specific to this product; they are not used in any other product.

### Languages Field
The list of languages that a person is proficient in, as stated in their resume.

A `ResumeV1Language` implements the following attributes:

* `language` (String): The language ISO 639 code.
* `level` (String): The level for the language. Possible values: 'Fluent', 'Proficient', 'Intermediate' and 'Beginner'.
Fields which are specific to this product; they are not used in any other product.

### Professional Experiences Field
The list of values that represent the professional experiences of an individual in their global resume.

A `ResumeV1ProfessionalExperience` implements the following attributes:

* `contract_type` (String): The type of contract for a professional experience. Possible values: 'Full-Time', 'Part-Time', 'Internship' and 'Freelance'.
* `department` (String): The specific department or division within a company where the professional experience was gained.
* `employer` (String): The name of the company or organization where the candidate has worked.
* `end_month` (String): The month when a professional experience ended.
* `end_year` (String): The year when a professional experience ended.
* `role` (String): The position or job title held by the individual in their previous work experience.
* `start_month` (String): The month when a professional experience began.
* `start_year` (String): The year when a professional experience began.
Fields which are specific to this product; they are not used in any other product.

### Social Networks Field
The list of URLs for social network profiles of the person.

A `ResumeV1SocialNetworksUrl` implements the following attributes:

* `name` (String): The name of of the social media concerned.
* `url` (String): The URL of the profile for this particular social network.

# Attributes
The following fields are extracted for Resume V1:

## Address
**address** ([StringField](#string-field)): The location information of the person, including city, state, and country.

```rb
puts result.document.inference.prediction.address.value
```

## Certificates
**certificates** (Array<[ResumeV1Certificate](#certificates-field)>): The list of certificates obtained by the candidate.

```rb
for certificates_elem in result.document.inference.prediction.certificates do
  puts certificates_elem.value
end
```

## Document Language
**document_language** ([StringField](#string-field)): The ISO 639 code of the language in which the document is written.

```rb
puts result.document.inference.prediction.document_language.value
```

## Document Type
**document_type** ([StringField](#string-field)): The type of the document sent, possible values being RESUME, MOTIVATION_LETTER and RECOMMENDATION_LETTER.

```rb
puts result.document.inference.prediction.document_type.value
```

## Education
**education** (Array<[ResumeV1Education](#education-field)>): The list of values that represent the educational background of an individual.

```rb
for education_elem in result.document.inference.prediction.education do
  puts education_elem.value
end
```

## Email Address
**email_address** ([StringField](#string-field)): The email address of the candidate.

```rb
puts result.document.inference.prediction.email_address.value
```

## Given Names
**given_names** (Array<[StringField](#string-field)>): The list of names that represent a person's first or given names.

```rb
for given_names_elem in result.document.inference.prediction.given_names do
  puts given_names_elem.value
end
```

## Hard Skills
**hard_skills** (Array<[StringField](#string-field)>): The list of specific technical abilities and knowledge mentioned in a resume.

```rb
for hard_skills_elem in result.document.inference.prediction.hard_skills do
  puts hard_skills_elem.value
end
```

## Job Applied
**job_applied** ([StringField](#string-field)): The specific industry or job role that the applicant is applying for.

```rb
puts result.document.inference.prediction.job_applied.value
```

## Languages
**languages** (Array<[ResumeV1Language](#languages-field)>): The list of languages that a person is proficient in, as stated in their resume.

```rb
for languages_elem in result.document.inference.prediction.languages do
  puts languages_elem.value
end
```

## Nationality
**nationality** ([StringField](#string-field)): The ISO 3166 code for the country of citizenship or origin of the person.

```rb
puts result.document.inference.prediction.nationality.value
```

## Phone Number
**phone_number** ([StringField](#string-field)): The phone number of the candidate.

```rb
puts result.document.inference.prediction.phone_number.value
```

## Profession
**profession** ([StringField](#string-field)): The area of expertise or specialization in which the individual has professional experience and qualifications.

```rb
puts result.document.inference.prediction.profession.value
```

## Professional Experiences
**professional_experiences** (Array<[ResumeV1ProfessionalExperience](#professional-experiences-field)>): The list of values that represent the professional experiences of an individual in their global resume.

```rb
for professional_experiences_elem in result.document.inference.prediction.professional_experiences do
  puts professional_experiences_elem.value
end
```

## Social Networks
**social_networks_urls** (Array<[ResumeV1SocialNetworksUrl](#social-networks-field)>): The list of URLs for social network profiles of the person.

```rb
for social_networks_urls_elem in result.document.inference.prediction.social_networks_urls do
  puts social_networks_urls_elem.value
end
```

## Soft Skills
**soft_skills** (Array<[StringField](#string-field)>): The list of values that represent a person's interpersonal and communication abilities in a global resume.

```rb
for soft_skills_elem in result.document.inference.prediction.soft_skills do
  puts soft_skills_elem.value
end
```

## Surnames
**surnames** (Array<[StringField](#string-field)>): The list of last names provided in a resume document.

```rb
for surnames_elem in result.document.inference.prediction.surnames do
  puts surnames_elem.value
end
```

# Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
