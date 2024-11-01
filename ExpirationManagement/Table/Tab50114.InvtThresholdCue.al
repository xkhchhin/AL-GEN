table 50114 "Invt. Threshold Cue"
{
    Caption = 'Invt. Threshold Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Integer)
        {
            Caption = 'Code';
        }
        field(2; Gray; Integer)
        {
            Caption = 'Gray';
            FieldClass = FlowField;
            CalcFormula = count("Item Ledger Entry" where("Expiration Category Level" = filter(None), "Remaining Quantity" = filter(> 0)));

        }
        field(3; Green; Integer)
        {
            Caption = 'Green';
            FieldClass = FlowField;
            CalcFormula = count("Item Ledger Entry" where("Expiration Category Level" = filter(Green), "Remaining Quantity" = filter(> 0)));

        }
        field(4; Orange; Integer)
        {
            Caption = 'Orange';
            FieldClass = FlowField;
            CalcFormula = count("Item Ledger Entry" where("Expiration Category Level" = filter(Orange), "Remaining Quantity" = filter(> 0)));

        }
        field(5; Red; Integer)
        {
            Caption = 'Red';
            FieldClass = FlowField;
            CalcFormula = count("Item Ledger Entry" where("Expiration Category Level" = filter(Red), "Remaining Quantity" = filter(> 0)));

        }
    }
    keys
    {
        key(PK; "Code")
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
