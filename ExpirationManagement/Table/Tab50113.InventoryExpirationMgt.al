table 50113 "Inventory Expiration Mgt."
{
    Caption = 'Inventory Expiration Mgt.';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Item Expiration Category"; Code[20])
        {
            Caption = 'Item Expiration Category';
            TableRelation = "Item Expiration Category".Code;
        }
        field(3; "Low Range"; enum "Invt. Expiration Range Style")
        {
            Caption = 'Low Range';
            DataClassification = ToBeClassified;
        }
        field(4; "Threshold 2"; Decimal)
        {
            Caption = 'Threshold 2';
        }
        field(5; "Middle Range"; enum "Invt. Expiration Range Style")
        {
            Caption = 'Middle Range';
            DataClassification = ToBeClassified;
        }
        field(6; "Threshold 3"; Decimal)
        {
            Caption = 'Threshold 3';
        }
        field(7; "High Range"; enum "Invt. Expiration Range Style")
        {
            Caption = 'High Range';
            DataClassification = ToBeClassified;
        }
        field(8; "Threshold 4"; Decimal)
        {
            Caption = 'Threshold 4';
        }
        field(9; "Write Off Range"; enum "Invt. Expiration Range Style")
        {
            Caption = 'Write Off Range';
            DataClassification = ToBeClassified;
        }
        field(10; "Threshold 1"; Decimal)
        {
            Caption = 'Threshold 1';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    procedure InsertIfNotExists()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
