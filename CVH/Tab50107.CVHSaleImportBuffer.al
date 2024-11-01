table 50107 "CVH Sale Import Buffer"
{
    Caption = 'CVH Sales Import Buffer';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Document Type"; Text[50])
        {
            Caption = 'Document No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Sell-To Customer No."; Code[20])
        {
            Caption = 'Sell-To Customer No.';
        }
        field(4; "Sell-To Customer Name"; Text[100])
        {
            Caption = 'Sell-To Customer Name';
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Payment Term Code"; Code[20])
        {
            Caption = 'Payment Term Code';
        }
        field(8; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
        }
        field(9; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
        }
        field(10; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(11; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(12; "External Document No."; Code[30])
        {
            Caption = 'External Document No.';
        }
        field(13; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibilty Center';
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
}
