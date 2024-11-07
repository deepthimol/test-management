// const cds = require('@sap/cds');
// const {
//     Tests
//     ,
//     Questions
//     } = cds.entities(
//     'DevChallengeService'
//     );
// module.exports = class DevChallengeService extends cds.ApplicationService {
//     async init() {
//         this.on('assignQuestionsToTest','Tests', async (req) => {
//             const   questionsCount = req.data.questionsCount;
//             const testId=req.params[0].testId;

//             // Constraint: The questionsCount should be at least 1
//             if (questionsCount < 1) {
//                 return req.error(400, 'The questionsCount must be at least 1.');
//             }

//             // Step 1: Validate the testId if provided
//             if (testId) {
//                 const test = await SELECT.one.from(Tests).where({ testId });
//                 // if (!test) {
//                 //     return req.error(404, `Test with ID ${testId} not found`);
//                 // }
//             }

//             // Step 2: Fetch available questions that are not assigned to any test
//             const availableQuestions = await SELECT.from(Questions)
//                 .where({ test_testId: null }); // Only questions without an associated test
//              console.log(availableQuestions,"1")
//             // Step 3: If no available questions, prompt the user to create questions
//             if (availableQuestions.length === 0) {
//                 return req.error(400, 'No available questions. Please create new questions.');
//             }

//             // Step 4: If available questions are less than requested, return an error
//             if (availableQuestions.length < questionsCount) {
//                 return req.error(400, `Not enough available questions. Found only ${availableQuestions.length} questions.`);
//             }

//             // Step 5: Assign the selected questions to the test (limit to questionsCount)
//             // const selectedQuestions = availableQuestions.slice(0, questionsCount);
//             const questions = await SELECT. from(Questions).limit(questionsCount)
//             .where('test_testId =', null );
//              for (let question of questions) {
//                 const lastlist=await UPDATE('testmanagement.Questions')
//                     .set({ test_testId: testId }) // Assign to the provided testId
//                     .where({ questionId: question.questionId })
//                     console.log(lastlist)
//                 console.log(await SELECT. from('testmanagement.Questions'))
//                 // const ID= question.questionId;
//                 // await UPDATE(Questions,ID).with({test_testId:testId})
//              }

//             // Step 6: Return success response
//             req.notify(`Assigned ${questionsCount} questions to the test with ID ${testId}`);
//             console.log(`Assigned ${questionsCount} questions to the test with ID ${testId}`)
//         });

//         this.on('createTest','Tests',async (req) => {
//             const questionText  = req.data.questionText;
//             const answerText  = req.data.answerText;

//             if (!questionText || !answerText) {
//                 return req.error(400, 'Both questionText and answerText are required.');
//             }
//             // Generate a unique ID for the questionId
//             const questionId = Math.random().toString(36).substring(2, 10);
//             const answerId=Math.random().toString(36).substring(2, 10);
     
//             // Insert the question into the Questions table
//             const questions={
//                 questionId: questionId,  // Use the generated UUID
//                 text: questionText ,
//                 answers: { answerId: answerId, text: answerText }  
//             }
         
//             await INSERT (questions).into (Questions) ;
//              console.log(await SELECT.from(Questions)) ;
            

//             return `Question and answer have been successfully created!`;

//         })


//         // Call the parent class's init method
//         return super.init();
//     }
// };

const cds = require('@sap/cds');
const {Tests,Questions,Suppliers} = cds.entities('DevChallengeService');

module.exports = class DevChallengeService extends cds.ApplicationService {
    async init() {
        this.on('assignQuestionsToTest','Tests', async (req) => {
            const   questionsCount = req.data.questionsCount;
            const ID=req.params[0].ID;

            // Constraint: The questionsCount should be at least 1
            if (questionsCount < 1) {
                return req.error(400, 'The questionsCount must be at least 1.');
            }

            // Step 1: Validate the testId if provided
            if (ID) {
                const test = await SELECT.one.from(Tests).where({ ID });
                if (!test) {
                    return req.error(404, `Test with ID ${ID} not found`);
                }
            }

            // Step 2: Fetch available questions that are not assigned to any test
            const availableQuestions = await SELECT.from(Questions)
                .where({ test_ID: null }); // Only questions without an associated test
             console.log(availableQuestions,"1")
            // Step 3: If no available questions, prompt the user to create questions
            if (availableQuestions.length === 0) {
                return req.error(400, 'No available questions. Please create new questions.');
            }

            // Step 4: If available questions are less than requested, return an error
            if (availableQuestions.length < questionsCount) {
                return req.error(400, `Not enough available questions. Found only ${availableQuestions.length} questions.`);
            }

            // Step 5: Assign the selected questions to the test (limit to questionsCount)
            // const selectedQuestions = availableQuestions.slice(0, questionsCount);
            const questions = await SELECT. from(Questions).limit(questionsCount)
            .where('test_ID =', null );
             for (let question of questions) {
                await UPDATE('testmanagement.Questions')
                    .set({ test_ID: ID }) // Assign to the provided testId
                    .where({ questionId: question.questionId })
                // const ID= question.questionId;
                // await UPDATE(Questions,ID).with({test_testId:testId})
             }

            // Step 6: Return success response
            req.notify(`Assigned ${questionsCount} questions to the test with ID ${ID}`);
        });

        this.on('createTest','Tests',async (req) => {
            const questionText  = req.data.questionText;
            const answerText  = req.data.answerText;

            if (!questionText || !answerText) {
                return req.error(400, 'Both questionText and answerText are required.');
            }
            // Generate a unique ID for the questionId
            const questionId = Math.random().toString(36).substring(2, 10);
            const answerId=Math.random().toString(36).substring(2, 10);
     
            // Insert the question into the Questions table
            const questions={
                questionId: questionId,  // Use the generated UUID
                text: questionText ,
                answers: { answerId: answerId, text: answerText }  
            }
         
            await INSERT (questions).into (Questions) ;
             console.log(await SELECT.from(Questions)) ;
            

            return `Question and answer have been successfully created!`;

        })

         const bupa = await cds.connect.to('API_BUSINESS_PARTNER');

  // Risks?$expand=supplier
  this.on("READ", 'Tests', async (req, next) => {
    if (!req.query.SELECT.columns) return next();
    const expandIndex = req.query.SELECT.columns.findIndex(
        ({ expand, ref }) => expand && ref[0] === "supplier"
    );
    if (expandIndex < 0) return next();

    // Remove expand from query
    req.query.SELECT.columns.splice(expandIndex, 1);

    // Make sure supplier_ID will be returned
    if (!req.query.SELECT.columns.indexOf('*') >= 0 &&
        !req.query.SELECT.columns.find(
            column => column.ref && column.ref.find((ref) => ref == "supplier_ID"))
    ) {
        req.query.SELECT.columns.push({ ref: ["supplier_ID"] });
    }

    const risks = await next();

    const asArray = x => Array.isArray(x) ? x : [ x ];

    // Request all associated suppliers
    const supplierIds = asArray(risks).map(risk => risk.supplier_ID);
    const suppliers = await bupa.run(SELECT.from(Suppliers).where({ ID: supplierIds }));

    // Convert in a map for easier lookup
    const suppliersMap = {};
    for (const supplier of suppliers)
        suppliersMap[supplier.ID] = supplier;

    // Add suppliers to result
    for (const note of asArray(risks)) {
        note.supplier = suppliersMap[note.supplier_ID];
    }

    return risks;
});


this.on('READ', 'Suppliers', async req => {
    return bupa.run(req.query);
});


        // Call the parent class's init method
        return super.init();
    }
};

