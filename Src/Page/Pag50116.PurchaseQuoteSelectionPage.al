page 50116 "Purchase Quote Selection Page"
{
    Caption = 'Purchase Quote Selection Page';
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Quote));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SelectPurchaseLine)
            {
                Caption = 'Select Purchase Line';
                ApplicationArea = All;
                trigger OnAction()
                var
                //  PurchaseLine: Record "Purchase Line";
                begin
                    AddtoComparisionLine();
                    // CurrPage.Close();
                    // CurrPage.SetSelectionFilter(PurchaseLine);
                end;
            }
        }
    }
    procedure SetComparisionNo(DocumentNo: Code[20])
    begin
        ComparisionNo := DocumentNo;
    end;

    local procedure AddtoComparisionLine()
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        QuotePriceLine: Record QuotePriceComparisonLine;
        NextNo: Integer;
    begin
        // if CloseAction = CloseAction::OK then begin
        PurchaseLine.Reset();
        CurrPage.SetSelectionFilter(PurchaseLine);
        if PurchaseLine.Count > 0 then
            repeat
                QuotePriceLine.Reset();
                QuotePriceLine.SetRange("Document No.", ComparisionNo);
                if QuotePriceLine.FindLast() then
                    NextNo := QuotePriceLine."Line No." + 10000
                else
                    NextNo := 10000;
                QuotePriceLine.Reset();
                QuotePriceLine.Init();
                QuotePriceLine."Line No." := NextNo;
                QuotePriceLine."Document No." := ComparisionNo;
                QuotePriceLine."No." := PurchaseLine."No.";
                QuotePriceLine.Description := PurchaseLine.Description;
                QuotePriceLine."Unit of Measure" := PurchaseLine."Unit of Measure Code";
                QuotePriceLine.Quantity := PurchaseLine.Quantity;
                QuotePriceLine."Unit Price" := PurchaseLine."Direct Unit Cost";
                QuotePriceLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";
                QuotePriceLine."Payment Term" := PurchaseHeader."Payment Terms Code";
                QuotePriceLine.Insert();
            until PurchaseLine.Next() = 0;
        // end else
        //     if Confirm('Do you really want to discard the current information?', true) then;
    end;

    var
        ComparisionNo: Code[20];
}
