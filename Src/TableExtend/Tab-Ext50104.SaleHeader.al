tableextension 50104 SaleHeader extends "Sales Header"
{
    fields
    {
        field(50100; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            // FieldClass = FlowField;
            // CalcFormula = lookup(Customer."Loan Amount" where("No." = field("Sell-to Customer No.")));
        }
        field(50101; "Imported"; Boolean)
        {
            Caption = 'Imported';
            DataClassification = ToBeClassified;
        }
        field(50102; "Imported DateTime"; DateTime)
        {
            Caption = 'Imported DateTime';
            DataClassification = ToBeClassified;
        }
        field(50103; "Imported ByuserID"; Text[100])
        {
            Caption = 'Imported By UserId';
            DataClassification = ToBeClassified;
        }
    }
}