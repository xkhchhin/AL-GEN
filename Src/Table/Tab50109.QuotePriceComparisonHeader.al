table 50109 QuotePriceComparisonHeader
{
    Caption = 'QuotePriceComparationHeader';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
        }
        field(4; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
        }
        field(5; "Comparison Date"; Date)
        {
            Caption = 'Comparison Date';
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,Released,Closed;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
