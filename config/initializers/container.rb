require 'dim'

ServiceContainer = Dim::Container.new
ServiceContainer.register(:content_object_service) do |c|
  ContentObjectService.new(
    ContentObjectRepository.new,
    ContentObjectScanner.new,
    c.content_objects_path)
end

ServiceContainer.register(:safety_plan_service) do |c|
  SafetyPlanService.new(SafetyPlanRepository.new)
end

ServiceContainer.register(:brochure_service) do |c|
  BrochureService.new(BrochureRepository.new)
end

ServiceContainer.register(:questionnaire_repository) do |c|
  Survey::QuestionnaireRepository.new
end

ServiceContainer.register(:answer_group_repository) do |c|
  Survey::AnswerGroupRepository.new
end

ServiceContainer.register(:survey_service) do |c|
  Survey::SurveyService.new(c.questionnaire_repository, c.answer_group_repository)
end

ServiceContainer.register(:therapist_service) do |c|
  TherapistService.new(c.party_repository)
end

ServiceContainer.register(:therapist_survey_service) do |c|
  TherapistSurveyService.new(c.questionnaire_repository,
                             c.answer_group_repository,
                             c.party_repository)
end

ServiceContainer.register(:client_chest_of_hope_service) do |c|
  ClientChestOfHopeService.new(c.hope_items_repository)
end

ServiceContainer.register(:admin_users_service) do |c|
  AdminUsersService.new(c.party_repository)
end

ServiceContainer.register(:admin_user_roles_service) do |c|
  AdminUserRolesService.new(c.party_repository, c.role_repository)
end

ServiceContainer.register(:frontend_users_service) do |c|
  FrontendUsersService.new(c.party_repository)
end

ServiceContainer.register(:hope_items_repository) do |c|
  HopeItemRepository.new
end

ServiceContainer.register(:role_repository) { RoleRepository.new }
ServiceContainer.register(:party_repository) { PartyRepository.new }

ServiceContainer.register(:principal) { Principal.new }

if Rails.env == 'development' || Rails.env == 'production'
  ServiceContainer.register(:content_objects_path) do
    (Rails.root + Pathname.new('public/content_objects')).to_s
  end
else
  ServiceContainer.register(:content_objects_path) do
    (Rails.root + Pathname.new('features/fixtures/content_objects')).to_s
  end
end
