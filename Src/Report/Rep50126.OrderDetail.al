report 50126 OrderDetail
{
    ApplicationArea = all;
    Caption = 'Order Detail (XKH)';
    DefaultLayout = RDLC;
    RDLCLayout = './Src/LayoutReport/OrderDetail.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", Status;
            RequestFilterHeading = 'Sales Order';
            column(CompanyName; CompanyName)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyNameN1; CompanyInfo.Name) { }
            column(SalesHeaderFilter; SalesHeader) { }
            column(DocumentNo_; "No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Posting_Date; "Posting Date") { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                column(No_; "No.") { }
                column(ItmDescription; Description) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(GetSelfNo; GetSelfNo("No.")) { }
                column(GetDescription; GetDescription("No.")) { }
                dataitem("Reservation Entry"; "Reservation Entry")
                {
                    DataItemLink = "Source ID" = field("Document No."), "Item No." = field("No.");
                    DataItemLinkReference = "Sales Line";
                    column(Lot_No_; "Lot No.") { }
                    column(Expiration_Date; "Expiration Date") { }
                }
            }

        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    local procedure GetSelfNo(var itemno: Code[20]): Code[20]
    var
        item: Record Item;
    begin
        item.Reset();
        item.SetRange("No.", itemno);
        if item.Find('-') then begin
            exit(item."Shelf No.");
        end;
    end;

    local procedure GetDescription(var itemno: Code[20]): text
    var
        item: Record Item;
    begin
        item.Reset();
        item.SetRange("No.", itemno);
        if item.Find('-') then begin
            exit(item.Description);
        end;
    end;

    trigger OnInitReport()
    var
        itemledgerentries: Record "Item Ledger Entry";
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
    end;

    trigger OnPreReport()
    begin
        SalesHeader := "Sales Header".GetFilters;
        CompanyInfo.Reset();
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.Get();
    end;

    var
        SalesHeader: Text[250];
        CompanyInfo: Record "Company Information";
}
