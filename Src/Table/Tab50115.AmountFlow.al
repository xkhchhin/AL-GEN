table 50115 "Amount Flow"
{
    Caption = 'Amount Flow';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; SalesPeople; Code[20])
        {
            Caption = 'SalesPeople';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(3; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
            // FieldClass = FlowField;
            // CalcFormula = Sum("Sales Invoice Header"."Amount Including VAT" WHERE("No." = FIELD(Code)));
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
