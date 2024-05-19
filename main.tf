module "table_authors" {
  source     = "./dynamodb"
  table_name = "authors"

}

module "table_courses" {
  source     = "./dynamodb"
  table_name = "courses"

}

module "iam" {
  source = "./iam"
  name   = "iam"

  dynamodb_authors_arn = module.table_authors.arn
  dynamodb_courses_arn = module.table_courses.arn
  sns_topic_arn         = module.sns.sns_topic_arn
}
module "lambda" {
  source              = "./lambda"
  name                = "lambda"
  get_all_courses_arn = module.iam.get_all_courses_role_arn
  get_all_authors_arn = module.iam.get_all_authors_role_arn
  get_course_arn = module.iam.get_course_role_arn
  save_course_arn = module.iam.save_course_role_arn
  update_course_arn = module.iam.update_course_role_arn
  delete_course_arn = module.iam.delete_course_role_arn
   sns_topic_arn = module.iam.sns_topic_lambda_arn
}
module "api" {
  source = "./api"
  name = "api"
  stage = "dev"


    get_all_authors_arn        = module.lambda.get_all_authors_arn
    get_all_authors_invoke_arn = module.lambda.get_all_authors_invoke_arn

    get_all_courses_arn        = module.lambda.get_all_courses_arn
    get_all_courses_invoke_arn = module.lambda.get_all_courses_invoke_arn
  
    get_course_arn        = module.lambda.get_course_arn
    get_course_invoke_arn = module.lambda.get_course_invoke_arn

    delete_course_arn        = module.lambda.delete_course_arn
    delete_course_invoke_arn = module.lambda.delete_course_invoke_arn

    save_course_arn        = module.lambda.save_course_arn
    save_course_invoke_arn = module.lambda.save_course_invoke_arn

    update_course_arn        = module.lambda.update_course_arn
    update_course_invoke_arn = module.lambda.update_course_invoke_arn
}

module "s3" {
  source = "./s3"
  name   = "s3"
  stage  = "dev"
}

module "cloudfront" {
  source = "./cloudfront"
  name   = "cloudfront"
  stage  = "dev"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
}


module "sns" {
  source = "./sns"
  name   = "sns"
  stage  = "dev"
  lambda_arn = module.lambda.sns_topic_arn
}