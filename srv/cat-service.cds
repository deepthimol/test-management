
// using testmanagement from '../db/data-model.cds';

// service DevChallengeService {
//     entity Tests as projection on testmanagement.Tests actions{
       
//          action assignQuestionsToTest( questionsCount: Integer)returns  String;
//          @Common.SideEffects: {
//             TargetEntities: ['DevChallengeService.Questions'],  // Declare side effects
//             Properties: ['test_testId']  // Properties affected by the action
//         }
         
//          action createTest(questionText:String,answerText:String)returns  String;
        
//     };
//     // annotate Tests with @odata.draft.enabled;

//     entity Questions as projection on testmanagement.Questions ;
//     // Action to assign questions to a test
// }

using testmanagement from '../db/data-model.cds';
//using from '@sap/cds-common-content';

service DevChallengeService{
   @odata.draft.enabled
    entity Tests  @(restrict: [
        {
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: '*',
            to   : 'RiskManager'
        },]) as projection on testmanagement.Tests actions {
             @cds.odata.bindingparameter.name: '_it'
            @Common.SideEffects : {
                TargetProperties: ['_it/questions']
                }
            @Common.IsActionCritical:true
           
           
        action assignQuestionsToTest(questionsCount: Integer) returns String;
        
        action createTest(questionText: String, answerText: String) returns String;

        
    }; 
    
    entity Questions @(restrict: [
        {
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: '*',
            to   : 'RiskManager'
        },]) as projection on testmanagement.Questions;


    entity Suppliers @(restrict: [{
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: '*',
            to   : 'RiskManager'
        },]) as projection on testmanagement.Suppliers;
}





