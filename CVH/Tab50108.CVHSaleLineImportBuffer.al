table 50108 "CVH Sale Line Import Buffer"
{
    Caption = 'CVH Sale Line Import Buffer';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Type"; Text[50])
        {
            Caption = 'Type';
        }
        field(2; "Document Type"; Code[20])
        {
            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; "Variant Code"; Code[20])
        {
            Caption = 'Variant Code';
        }
        field(7; Qty; Decimal)
        {
            Caption = 'Qty';
        }
        field(8; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(9; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }
        field(10; "Unit Price Includ. Vat"; Decimal)
        {
            Caption = 'Unit Price Includ. Vat';
        }
        field(11; "Unit Of Measure Code"; Code[20])
        {
            Caption = 'Unit Of Measure Code';
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(13; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        field(14; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
        }
        field(15; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
        }
        field(16; "Line No."; Integer)
        {
            Caption = 'Line No';
        }
        field(17; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
        }
    }
    keys
    {
        key(PK; "Document No.", "No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
