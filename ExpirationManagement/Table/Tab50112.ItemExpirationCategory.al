table 50112 "Item Expiration Category"
{
    Caption = 'Item Expiration Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "No. Of Item"; Integer)
        {
            Editable = false;
            Caption = 'No. Of Item';
            FieldClass = FlowField;
            CalcFormula = count(Item where("Item Expiration Category" = field(Code)));
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
