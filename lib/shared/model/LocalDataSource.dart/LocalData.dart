import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:seen/Features/Sections/model/classes/IndexedSubjects.dart';
import 'package:sqflite/sqflite.dart';

const String indexedSubjectTable = 'indexedSubjectTable';
const String tableSubject = 'subject';
const String subjectIdAuto = 's_id';
const String subjectId = 'id';
const String subjectName = 'subject_name';
const String subjectNotes = 'subject_notes';
const String subjectTerm = 'term';
const String subjectLang = 'language';
const String subjectBacId = 'bachelor_id';
const String subjectYearId = 'year_id';
const String codeId = "subject_code";
const String couponId = "subject_coupon";
const String subjectIndex = 'subjectIndex';
const String hasData = 'has_data';
const String hasUnloacked = 'has_unloacked';
const String openSubject = 'open_subject';
//################################################
const String tableSubSubject = 'subSubject';
const String subSubjectIdAuto = 'sub_subject_id';
const String subSubjectId = 'id';
const String subSubjectName = 'sub_subject_name';
const String subSubjectNotes = 'sub_subject_notes';
const String subjectIdForSubSub = 'subject_id';
const String fatherId = 'father_id';
const String sort = 'sort';
const String isLatex = 'is_latex';
const String is_unlocked = 'is_unlocked';
const String openSubSubject = 'open_sub_subject';
//######const String fatherId = 'father_id';###########################################
const String tableQuestion = 'question';
const String questionIdAuto = 'q_id';
const String questionId = 'id';
const String hurl = 'h_url';
const String questionContent = 'question_content';
const String questionNotes = 'question_notes';
const String isMcqColumn = 'is_mcq';
const String

    /// The `questionSubjectID` is a column in the `question` table that stores the ID of the
    /// subject to which the question belongs. This column is used to establish a relationship
    /// between questions and subjects in the database. It helps in organizing and retrieving
    /// questions based on their associated subjects.
    questionSubjectID = 'subject_id';
const String questionSubSubjectId = 'sub_subject_id';
const String previousId = 'previous_id';
const String answerColumn = 'answer';
const String isWrong = 'is_wrong';
const String isFavorite = 'is_favorite';
const String note = 'note';
const String qurl = 'q_url';
const String rightTimes = 'right_times';
const String wrongTimes = 'wrong_times';
const String nextShowDate = 'next_show_date';
//################################################
const String tableAnswer = 'answer';
const String answerIdAuto = 'answer_id';
const String answerId = 'id';
const String answerContent = 'answer_content';
const String answerNotes = 'answer_notes';
const String correctnessColumn = 'correctness';
const String answerQuestionId = 'question_id';
const String aurl = 'a_url';
//################################################
const String tableCodes = 'codes';
const String codeIdAuto = 'co_id';
const String codeIdentity = 'id';
const String codeContent = 'code_content';
const String codeName = 'code_name';
const String codeNotes = 'code_notes';
const String expiryTime = 'expiry_time';
const String dateOfActivation = 'date_of_activation';
const String isActive = 'is_active';
const String userId = 'user_id';
const String iscoupon = 'iscoupon';
//#######################################
const String tableCurrentSession = 'CurrentSession';
const String currentSessionAutoId = 'cs_id';
const String question_id = 'q_id';
const String csSubId = 'cs_sub_id';
const String csSubjectID = 'cs_subject_id';
const String choice = 'choice';
const String correctIndex = "correctIndex";
const String answer_index = 'a_index';
const String alreadyChecked = 'already_hecked';
const String questionIndex = 'q_index';
const String cspreviousIdCol = 'prev_id';
const String isRandomize = 'is_randomize';
const String isPrevious = 'is_prev';
const String isWrongness = 'is_wrong';
const String isfav = 'is_fave';
const String isAllWrongness = 'is_all_wrong';
const String isAllfav = 'is_all_fave';
//###############################################
const String tablePrevious = 'previous';
const String previousIdAuto = 'prev_id';
const String previousIdCol = 'id';
const String previousName = 'previous_name';
const String previousNotes = 'previous_notes';
const String previousSubjectId = 'subject_id';
//###############################################
const String tableRandomIdSession = 'random_q_id_sessin';
const String randomQuestionAutoId = 'random_q_autoid';
const String randomQuestionId = 'random_qid';
const String randomQuestionIndex = 'random_index';
//###############################################
const String tableLinks = 'links';
const String linksAutoId = 'link_id';
const String linksId = 'id';
const String linkDescription = 'link_description';
const String linkUrl = 'url';

//###############################################

const String tableActiveCodes = 'Active_codes';
const String activeCodesAutoId = 'active_id';
const String activeCodeId = 'id';
const String activeCodeName = 'code_name';
const String endDate = 'end_date';
const String activationDate = 'date_of_activation';
const String subjectIdForCode = 'subject_id';
const String isActiveCode = 'is_active';
const String userID = 'user_id';
//###############################################
const String tableActiveCoupons = 'Active_coupons';
const String activeCouponsAutoId = 'active_Coupons_id';
const String activeCouponsId = 'id';
const String name = 'coupon_content';
//###############################################
const String userAnswers = 'user_answers';
const String userAnswersAutoId = 'user_nswers_id';
const String userAnswersID = 'id';
//###############################################
const String wrongQuestion = 'user_wrong_question';
const String wrongQuestionAutoId = 'wrong_answers_auto_id';
const String wronganswerID = 'id';
const String subjectID = 'subject_id';

//###############################################
class SubjectLocalDataSource {
  static SubjectLocalDataSource instance = SubjectLocalDataSource();
  Database? _dbe;

  Future<Database?> get dbe async {
    if (_dbe == null) {
      _dbe = await initializeDb();
      return _dbe;
    } else {
      return _dbe;
    }
  }

  initializeDb() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'seen.db');
    Database myDb = await openDatabase(path,
        onCreate: _onCreate, version: 5, onUpgrade: _onUpgrade);
    return myDb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // await db
      //     .execute("ALTER TABLE $tableQuestion ADD COLUMN $wrongTimes INT;");
      // await db
      //     .execute("ALTER TABLE $tableQuestion ADD COLUMN $rightTimes INT;");

      // await db
      //     .execute("ALTER TABLE $tableQuestion ADD COLUMN $nextShowDate TEXT;");
      // // await db
      //     .execute("ALTER TABLE $tableSubject ADD COLUMN $openSubject INT;");
      // await db
      //     .execute("ALTER TABLE $tableSubject ADD COLUMN $hasUnloacked INT;");
      // await db.execute("ALTER TABLE $tableSubject ADD COLUMN $hasData INT;");
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
create table $tableSubject ( 
  $subjectIdAuto INTEGER PRIMARY KEY  AUTOINCREMENT,
  $subjectId INT NOT NULL , 
  $subjectName TEXT NOT NULL,
  $subjectNotes TEXT,
  $subjectTerm TEXT,
  $subjectLang VARCHAR(250) NOT NULL,
  $subjectBacId INT,
  $subjectYearId INT,
  $codeId INT ,
  $couponId INT,
  $hasData INT,
  $hasUnloacked INT,
  $openSubject INT
  )
''');
//######################################################
    await db.execute('''
create table $tableLinks ( 
  $linksAutoId INTEGER PRIMARY KEY  AUTOINCREMENT,
  $linksId INT NOT NULL , 
  $linkDescription TEXT ,
  $linkUrl TEXT
  )
''');

    //#########################################################
    await db.execute('''
create table $userAnswers ( 
  $userAnswersAutoId INTEGER PRIMARY KEY  AUTOINCREMENT,
  $userAnswersID INT NOT NULL , 
  $correctnessColumn INT NOT NULL
  )
''');
//#########################################################
    //#########################################################
//     await db.execute('''
// create table $wrongQuestion (
//   $wrongQuestionAutoId INTEGER PRIMARY KEY  AUTOINCREMENT,
//   $wronganswerID INT NOT NULL ,
//   $subjectID INT
//   )
// ''');
//#########################################################
    await db.execute('''
create table $tablePrevious ( 
  $previousIdAuto INTEGER PRIMARY KEY  AUTOINCREMENT,
  $previousIdCol INT NOT NULL , 
  $previousName TEXT NOT NULL,
  $previousNotes TEXT,
  $previousSubjectId INT
  )
''');
//##########################indexed#################################################
    await db.execute('''
create table $indexedSubjectTable ( 
  $subjectIdAuto INTEGER PRIMARY KEY  AUTOINCREMENT,
  $subjectId INT NOT NULL , 
  $subjectName TEXT NOT NULL,
  $subjectLang VARCHAR(250) NOT NULL,
  $codeId INT,
  $subjectIndex INT,
  $couponId INT ,
  $subjectTerm TEXT,
  $subjectBacId INT,
  $hasData INT,
  $hasUnloacked INT,
  $openSubject INT
  )
''');

//##########################ActiveCodes#################################################
    await db.execute('''
create table $tableActiveCodes ( 
  $activeCodesAutoId INTEGER PRIMARY KEY  AUTOINCREMENT,
  $activeCodeId INT NOT NULL , 
  $activationDate VARCHAR(250) NOT NULL,
  $endDate VARCHAR(250) NOT NULL,  
  $activeCodeName TEXT ,
  $subjectIdForCode INT NOT NULL,
  $isActiveCode INT,  $expiryTime INT,
  $userID INT NOT NULL
  )
''');
//##########################ActiveCoupon#################################################
    await db.execute('''
create table $tableActiveCoupons ( 
  $activeCouponsAutoId INTEGER PRIMARY KEY  AUTOINCREMENT,
  $activeCouponsId INT NOT NULL , 
  $name TEXT   , 
  $endDate VARCHAR(250) NOT NULL,
  $subjectIdForCode INT NOT NULL,
  $isActiveCode INT,
  $activationDate VARCHAR(250) NOT NULL,
  $expiryTime INT
  )
''');
//############################SubSubject###############################################
    await db.execute('''
create table $tableSubSubject ( 
  $subSubjectIdAuto INTEGER PRIMARY KEY  AUTOINCREMENT,
  $subSubjectId INT NOT NULL UNIQUE, 
  $subSubjectName TEXT NOT NULL,
  $subSubjectNotes TEXT,
  $subjectIdForSubSub INT NOT NULL,
  $fatherId INT,
  $sort INT,
  $isLatex INT,$is_unlocked INT,$openSubSubject INT,$hasData INT,
  FOREIGN KEY (father_id) REFERENCES sub_subject(sub_subject_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE)
''');
//#########################Answer###############################
    await db.execute('''
create table $tableAnswer ( 
  $answerIdAuto INTEGER PRIMARY KEY  AUTOINCREMENT,
  $answerId INT NOT NULL UNIQUE, 
  $answerContent TEXT NOT NULL,
  $answerNotes TEXT,
  $correctnessColumn TINYINT(1) NOT NULL,
  $answerQuestionId INT, 
  $aurl TEXT,
  FOREIGN KEY (question_id) REFERENCES question(question_id) ON DELETE CASCADE
)
''');
//###########################Question#######################################
    await db.execute('''
create table $tableQuestion ( 
  $questionIdAuto INTEGER PRIMARY KEY  AUTOINCREMENT,
  $questionId INT NOT NULL , 
  $questionContent TEXT NOT NULL,
  $questionNotes TEXT,
  $isMcqColumn INT NOT NULL,
  $questionSubSubjectId VARCHAR(250),
  $previousId TEXT,
  $isWrong INT,  $questionSubjectID INT,
  $isFavorite INT,
  $note TEXT, $hurl TEXT,
  $qurl TEXT,
  $rightTimes INT,
  $wrongTimes INT,
  
  $nextShowDate VARCHAR(250),
  FOREIGN KEY (sub_subject_id) REFERENCES sub_subject(sub_subject_id) ON DELETE CASCADE
)
''');
//add total rightTimes
//########################UserCode#############################
    await db.execute('''
create table $tableCodes ( 
  $codeIdAuto INTEGER PRIMARY KEY  AUTOINCREMENT,
  $codeIdentity INT NOT NULL UNIQUE, 
  $codeContent TEXT NOT NULL,
  $codeNotes TEXT,
  $codeName TEXT,
  $expiryTime INT,
  $dateOfActivation TEXT,
  $isActive INT,
  $userId INT,
  $iscoupon INT
)
''');
//########################CurentSession#############################
    await db.execute('''
create table $tableCurrentSession ( 
  $currentSessionAutoId INTEGER PRIMARY KEY  AUTOINCREMENT,
  $csSubId INT , 
  $csSubjectID INT ,
  $question_id INT NOT NULL , 
  $choice TEXT,
  $questionIndex INT NOT NULL ,
  $correctnessColumn INT NOT NULL,
  $answer_index INT NOT NULL,
  $answerContent TEXT,
  $alreadyChecked INT NOT NULL,
  $correctIndex INT NOT NULL,
  $cspreviousIdCol INT ,
  $isRandomize INT NOT NULL,
  $isPrevious INT NOT NULL,
  $isfav INT NOT NULL,
  $isWrong INT NOT NULL, 
  $isAllWrongness INT NOT NULL,
  $isAllfav INT NOT NULL
)
''');
//############################################################
    await db.execute('''
create table $tableRandomIdSession ( 
  $randomQuestionAutoId INTEGER PRIMARY KEY  AUTOINCREMENT,
  $randomQuestionId INT NOT NULL,
  $randomQuestionIndex INT NOT NULL
 
)
''');
    if (kDebugMode) {
      //print(" onCreate =====================================");
    }
  }

  Future close() async {
    final db = await dbe;
    db!.close();
  }
}
