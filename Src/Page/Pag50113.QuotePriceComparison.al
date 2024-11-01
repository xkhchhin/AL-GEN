page 50113 "Quote Price Comparison"
{
    Caption = 'Quote Price Comparison';
    PageType = Document;
    SourceTable = QuotePriceComparisonHeader;
    PromotedActionCategories = 'New,Process,Report,Quote,View,Approve,Request Approval,History,Print/Send,Release,Navigate';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    Editable = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Editable = true;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                    Editable = true;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                    Editable = true;
                }
                field("Comparison Date"; Rec."Comparison Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comparison Date field.', Comment = '%';
                    Editable = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Editable = false;
                }
            }
            part(Lines; "Quote Price Comparison Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Get Lines")
            {
                ApplicationArea = All;
                Image = Line;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SelectLine: Page "Purchase Quote Selection Page";
                begin
                    SelectLine.SetComparisionNo(Rec."No.");
                    SelectLine.Run();
                end;
            }
            action("Get Purchase Quote")
            {
                ApplicationArea = All;
                Image = PostedCreditMemo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PurchaseLine: Record "Purchase Line";
                begin
                    GetPurchaseLine();
                end;
            }
        }
    }
    local procedure GetPurchaseLine()
    var
        PurchaseLine: Record "Purchase Line";
        SourcePurchaseLine: code[50];
    begin
        PurchaseLine.SetFilter("Document Type", 'Quote');
        if PAGE.RunModal(Page::"Purchase Quote Selection Page", PurchaseLine) = ACTION::LookupOK then begin
            SourcePurchaseLine := PurchaseLine."Document No.";
            AddPurchaseLineToQuotePrice(PurchaseLine);
        end else
            Error('No source purchase selected.');
    end;

    local procedure AddPurchaseLineToQuotePrice(var PurchaseLine: Record "Purchase Line")
    var
        QuotePriceLine: Record QuotePriceComparisonLine;
        PurchaseLines: Record "Purchase Line";
        NextNo: Integer;
    begin
        PurchaseLine.SetFilter("Document Type", 'Quote');
        if PurchaseLine.FindSet() then
            repeat
                if QuotePriceLine.Find() then
                    NextNo := QuotePriceLine."Line No." + 10000
                else
                    NextNo := 10000;
                QuotePriceLine.Init();
                QuotePriceLine."Line No." := NextNo;
                QuotePriceLine."Document No." := Rec."No.";
                QuotePriceLine."No." := PurchaseLine."No.";
                QuotePriceLine.Description := PurchaseLine.Description;
                QuotePriceLine."Unit of Measure" := PurchaseLine."Unit of Measure Code";
                QuotePriceLine.Quantity := PurchaseLine.Quantity;
                QuotePriceLine."Unit Price" := PurchaseLine."Direct Unit Cost";
                QuotePriceLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";
                QuotePriceLine.Insert();
            until PurchaseLine.Next() = 0;
    end;

    var
        QuotePriceDocNo: code[20];
}
