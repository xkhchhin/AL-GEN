table 50110 QuotePriceComparisonLine
{
    Caption = 'QuotePriceComparisonLine';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Item."No.";
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(7; "Comparison Date"; Date)
        {
            Caption = 'Comparison Date';
        }
        field(8; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
        }
        field(9; "Payment Term"; Code[20])
        {
            Caption = 'Payment Term';
        }
        field(10; "Expected Receipt Date"; date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(11; "Buy-From Vendor No."; code[20])
        {
            Caption = 'Buy-From Vendor No.';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
