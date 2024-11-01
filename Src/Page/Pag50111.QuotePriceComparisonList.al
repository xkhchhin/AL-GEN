page 50111 "Quote Price Comparison List"
{
    ApplicationArea = All;
    Caption = 'Quote Price Comparison List';
    PageType = List;
    SourceTable = QuotePriceComparisonHeader;
    UsageCategory = Lists;
    CardPageId = "Quote Price Comparison";
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Quote';
    Editable = false;

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
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Comparison Date"; Rec."Comparison Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comparison Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }

    }
}
