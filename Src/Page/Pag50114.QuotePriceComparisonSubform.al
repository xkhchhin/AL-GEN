page 50114 "Quote Price Comparison Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = QuotePriceComparisonLine;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.', Comment = '%';
                }
                field("Payment Term"; Rec."Payment Term")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Term field.', Comment = '%';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("Comparison Date"; Rec."Comparison Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comparison Date field.', Comment = '%';
                }
            }
        }
    }
    actions
    {

    }
}
