table 50111 "IC Data Copy Setup"
{
    Caption = 'IC Data Copy Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Code[10])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "From Company"; Text[30])
        {
        }
        field(4; "To Company"; Text[30])
        {
        }
        field(5; "Commit After Table Copy"; Boolean)
        {
        }
        field(6; Active; Boolean)
        {
        }
    }
    keys
    {
        key(key1; Name)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; Name)
        {
        }
    }
}
