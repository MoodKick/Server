# encoding: UTF-8
require_relative '../spec/daily_journal_entries_generator'

jens = User.new(username: 'jens',
  full_name: 'Jens Jensen',
  email: 'jens-testuser@moodkick.com',
  password: 'jenspass',
  password_confirmation: 'jenspass',
  avatar_url: 'http://dev.moodkick.com/images/avatars/avatar-03-large.png',
  location: 'Midtjylland',
  description: "My name is Jens, and I'm on MoodKick because I am a relative to a person who is mentally vulnerable.")
jens.add_role(Role::Client)
jens.ensure_authentication_token
jens.save!

u = User.new(username: 'ane',
  full_name: 'Ane Anesen',
  email: 'ane-testuser@moodkick.com',
  password: 'anepass',
  password_confirmation: 'anepass',
  avatar_url: 'http://dev.moodkick.com/images/avatars/avatar-01-large.png',
  location: 'Sjælland',
  description: "My name is Ane, and I'm on MoodKick because I am a mentally vulnerable person who would like to get better.")
u.add_role(Role::Relative)
u.ensure_authentication_token
u.save!

mikkel = User.new(username: 'mikkel',
  full_name: 'Mikkel Mikkelsen',
  email: 'mikkel-testuser@moodkick.com',
  password: 'mikkelpass',
  password_confirmation: 'mikkelpass',
  avatar_url: 'http://dev.moodkick.com/images/avatars/avatar-04-large.png',
  location: 'Syddanmark',
  description: "My name is Mikkel, and I'm on MoodKick because I am a therapist who would like to offer my expertise to people suffering from being mentally vulnerable.")
mikkel.add_role(Role::Therapist)
mikkel.ensure_authentication_token
mikkel.save

u = User.new(username: 'signe',
  full_name: 'Signe Signesen',
  email: 'signe-testuser@moodkick.com',
  password: 'signepass',
  password_confirmation: 'signepass',
  avatar_url: 'http://dev.moodkick.com/images/avatars/avatar-02-large.png',
  location: 'Syddanmark',
  description: "My name is Signe, and I'm on MoodKick because I am a mentally vulnerable person who would like to get better.")
u.add_role(Role::Therapist)
u.ensure_authentication_token
u.save!

MoodKick::Test::DailyJournalEntriesGenerator.generate(jens)

u = User.new(username: 'admin',
  full_name: 'admin',
  email: 'admin@moodkick.com',
  password: 'adminpass',
  password_confirmation: 'adminpass',
  location: 'Syddanmark',
  description: "I am the mighty admin.")
u.add_role(Role::Admin)
u.ensure_authentication_token
u.save!

taking_life_question = Survey::SingleChoiceQuestion.new({
    description: 'I have thoughts of taking my own life' })
taking_life_question.add_choice(Survey::Choice.new(id: 1, value: 'Never'))
taking_life_question.add_choice(Survey::Choice.new(id: 2, value: 'Seldom'))
taking_life_question.add_choice(Survey::Choice.new(id: 3, value: 'Sometimes'))
taking_life_question.add_choice(Survey::Choice.new(id: 4, value: 'Often'))
taking_life_question.add_choice(Survey::Choice.new(id: 5, value: 'Very often'))

questions = []
questions.push(taking_life_question)

questions.push(Survey::MeasurableQuestion.new(
  description: 'Rate your level of psychological pain',
  unit: Survey::Unit.new({
    min_value: 1,
    max_value: 5,
    min_value_description: 'Low',
    max_value_description: 'High'
  })
))

questions.push(Survey::MeasurableQuestion.new(
  description: 'Rate your level of stress',
  unit: Survey::Unit.new({
    min_value: 1,
    max_value: 5,
    min_value_description: 'Low',
    max_value_description: 'High'
  })
))

questions.push(Survey::MeasurableQuestion.new(
  description: 'Rate your level of unrest',
  unit: Survey::Unit.new({
    min_value: 1,
    max_value: 5,
    min_value_description: 'Low',
    max_value_description: 'High'
  })
))

questions.push(Survey::MeasurableQuestion.new(
  description: 'Rate your level of hopelessness',
  unit: Survey::Unit.new({
    min_value: 1,
    max_value: 5,
    min_value_description: 'Low',
    max_value_description: 'High'
  })
))

questions.push(Survey::MeasurableQuestion.new(
  description: 'Rate your level of self-hate',
  unit: Survey::Unit.new({
    min_value: 1,
    max_value: 5,
    min_value_description: 'Low',
    max_value_description: 'High'
  })
))

questions.push(Survey::MeasurableQuestion.new(
  description: 'Rate your overall risk of committing suicide',
  unit: Survey::Unit.new({
    min_value: 1,
    max_value: 5,
    min_value_description: 'Extremely low risk',
    max_value_description: 'Extremely high risk'
  })
))

#keywords_question = Survey::MultipleChoiceQuestion.new(
  #description: 'Keywords')
#keywords_question.add_choice(Survey::Choice.new(id: 1, value: 'Calm'))
#keywords_question.add_choice(Survey::Choice.new(id: 2, value: 'Angry'))
#keywords_question.add_choice(Survey::Choice.new(id: 3, value: 'Anxious'))
#keywords_question.add_choice(Survey::Choice.new(id: 4, value: 'Manic'))

#name_day_question = Survey::TextQuestion.new(description: 'Name the day')

questionnaire = Survey::Questionnaire.new(title: 'Depression Test')
questionnaire.add_question(1, questions[0])
questionnaire.add_question(2, questions[1])
questionnaire.add_question(3, questions[2])
questionnaire.add_question(4, questions[3])
questionnaire.add_question(5, questions[4])
questionnaire.add_question(6, questions[5])
questionnaire.add_question(7, questions[6])

questionnaire.save

SafetyPlanService.new(SafetyPlanRepository.new).create(
  { body: '<h1>Your Safety Plan</h1>Welcome to your safety plan, which is developed to help you know in-situ how to get the help you need.<br><br>1) Use your positive affirmations<br>2) Contact your resource people<br>3) Call your therapist or a support hotline (<span class="wysiwyg-color-green">see section "Help"</span>)<br><br><span class="wysiwyg-color-red">If you cannot get through to your therapist, and you feel that you need urgent help, call 9-1-1.</span><br>' },
  jens.id, mikkel)

ServiceContainer.therapist_service.make_primary_therapist(jens.id, mikkel.id)
ServiceContainer.brochure_service.update_help('<h1>Getting help</h1>This brochure describes the many ways in which you may get help.<br><br><span class="wysiwyg-color-red">If you feel urgently&nbsp;threatened, call 9-1-1 directly.&nbsp;<br></span><br><h2><b>Sind</b></h2>If you have mental health problems which you would like to discuss with friendly and competent people, you may call Sind\'s Hotline.<br><br><b>Phone:&nbsp;70 23 27 50 </b><br>(Mon-Fri 11-22 and Sun 17-22)<b><br></b>Web: <a rel="nofollow" target="_blank" href="http://www.sind.dk">www.sind.dk</a><br><b><br></b><h2><b>Livslinien</b></h2>If you have suicidal thoughts, you may call Livslinien and talk with friendly and&nbsp;competent&nbsp;staff.<br><br><b>Phone: 70 201 201</b><br>Web: <a rel="nofollow" target="_blank" href="http://www.livslinien.dk">www.livslinien.dk</a><br><br><br>')
