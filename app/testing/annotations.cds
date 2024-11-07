using DevChallengeService as service from '../../srv/cat-service';
using from '../../db/data-model';



annotate service.Tests with @(

    UI.LineItem      : [
        {
            $Type : 'UI.DataField',
            Label : 'Title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Value : price,
            Label : 'Price',
        },
        {
            $Type : 'UI.DataField',
            Label : 'Created By',
            Value : createdBy,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Created At',
            Value : createdAt,
        },
        {
            $Type : 'UI.DataField',
            Label : 'BusinessPartner',
            Value : supplier.fullName,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : 'rating',
            Target : '@UI.DataPoint#rating',
            ![@UI.Importance] : #High,
        },
    ],
    UI.HeaderInfo    : {
        Title         : {
            $Type: 'UI.DataField',
            Value: title,
        },
        TypeName      : 'Test',
        TypeNamePlural: 'Tests',
    },
    UI.Identification: [
        {
            $Type : 'UI.DataFieldForAction',
            //  Determining : true,
            Action: 'DevChallengeService.assignQuestionsToTest',
            Label : 'Assign Questions to Test',
        //  Criticality: #Positive,  // This should be defined properly in your context

        },
        {
            $Type      : 'UI.DataFieldForAction',
            Action     : 'DevChallengeService.createTest',
            Label      : 'createTest',
            Criticality: #Positive,
        },
    ],
    UI.DataPoint #rating : {
        Value : rating,
        TargetValue : 5,
        Visualization : #Rating,
    },
    
);




annotate service.Tests with @(

    UI.FieldGroup #TestDetails: {

        $Type: 'UI.FieldGroupType',

        Data : [

            {

                $Type: 'UI.DataField',
                Label: 'Title',
                Value: title,

            },

            {

                $Type: 'UI.DataField',
                Label: 'Description',
                Value: description,

            },
            {
                $Type : 'UI.DataField',
                Value : price,
                Label : 'Price'
            },
             {

                $Type: 'UI.DataField',
                Label: 'Created By',
                Value: createdBy,

            },
            {

                $Type: 'UI.DataField',
                Label: 'Created At',
                Value: createdAt,

            },
            {Label: 'BusinessPartner',
                Value: supplier_ID},
                {Value: supplier.isBlocked},
            {
                $Type : 'UI.DataField',
                Value : rating,
                Label : 'rating',
            },
            // {
            //     $Type : 'UI.DataFieldForAnnotation',
            //     Target : 'supplier/@Communication.Contact#contact1',
            //     Label : '{i18n>BusinessPartner}',
            // },
        ],

    },


    UI.Facets                 : [
        {

            $Type : 'UI.ReferenceFacet',
            ID    : 'TestDetailsFacet',
            Label : 'Test Details',
            Target: '@UI.FieldGroup#TestDetails',

        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Questions',
            ID    : 'Questions',
            Target: 'questions/@UI.LineItem#Questions',
        },
    ]

);

annotate service.Questions with @(
    UI.Facets             : [{
        $Type : 'UI.ReferenceFacet',
        Target: 'test/@UI.LineItem',
        Label : 'Questions',
        ID    : 'questions',
    }, ],
    UI.LineItem #Questions: [
        {
            $Type: 'UI.DataField',
            Value: text,
            Label: 'Question text',
        },
        {
            $Type: 'UI.DataField',
            Value: answers.text,
            Label: 'Answer Text',
        },
    ],
);
// annotate service.Tests with {
//     currency @Common.Text : currency_code
// };

// annotate service.Tests with {
//     price @Common.ValueList : {
//         $Type : 'Common.ValueListType',
//         Label : '',
//         CollectionPath : 'Tests',
//         Parameters : [
//             {
//                 $Type : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : price,
//                 ValueListProperty : 'price',
//             },
//         ],
//     }
// };

annotate service.Tests with {
   price @Measures : { ISOCurrency : currency_code }
}

annotate DevChallengeService.Tests with  {
 @Common.ValueListWithFixedValues : true
    @Common.ValueList : {
        $Type : 'Common.ValueListType',
        Label : 'Currency',
        CollectionPath : 'Currencies',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : currency_code,
                ValueListProperty : 'code'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    }
    @Core.Description : 'A currency code as specified in ISO 4217'
    currency
};


// Annotations for value help

annotate service.Tests with {
    supplier @(
        Common.ValueList: {
            Label: 'Suppliers',
            CollectionPath: 'Suppliers',
            Parameters: [
                { $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: supplier_ID,
                    ValueListProperty: 'ID'
                },
                { $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'fullName'
                }
            ]
        },
        Common.Text : {
            $value : supplier.fullName,
            ![@UI.TextArrangement] : #TextFirst
        },
    );
}

annotate service.Suppliers with {
    ID@(
        title: 'ID',
        Common.Text: fullName
    );
    fullName    @title: 'Name';
}

annotate service.Suppliers with {
    isBlocked   @title: 'Supplier Blocked';
}

annotate service.Suppliers with @Capabilities.SearchRestrictions.Searchable : false;

