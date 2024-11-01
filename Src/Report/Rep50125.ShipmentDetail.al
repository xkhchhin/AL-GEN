report 50125 ShipmentDetail
{
    ApplicationArea = all;
    Caption = 'Shipment Detail (XKH)';
    DefaultLayout = RDLC;
    RDLCLayout = './Src/LayoutReport/ShipmentDetail.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            RequestFilterFields = "Posting Date", "Document No.";
            RequestFilterHeading = 'Detail Sales Shipment';
            DataItemTableView = sorting("Entry No.") where("Entry Type" = const("Sale"), "Document Type" = const("Sales Shipment"));
            column(CompanyName; CompanyName)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyNameN1; CompanyInfo.Name) { }
            column(ItemLedgerFilter; ItemLedgerFilter)
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(Description; Description)
            {
            }
            column(UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(LotNo; "Lot No.")
            {
            }
            column(ExpirationDate; "Expiration Date")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(GetSelfNo; GetSelfNo("Item No.")) { }
            column(GetDescription; GetDescription("Item No.")) { }
            dataitem("Sales Shipment Header"; "Sales Shipment Header")
            {
                DataItemLink = "No." = FIELD("Document No.");
                DataItemLinkReference = ItemLedgerEntry;
                column(Bill_to_Customer_No_; "Bill-to Customer No.")
                { }
                column(Bill_to_Name; "Bill-to Name") { }
                column(Ship_to_Name; "Ship-to Name") { }
                column(Shipment_Date; "Shipment Date") { }
                dataitem("Sales Shipment Line"; "Sales Shipment Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    DataItemLinkReference = "Sales Shipment Header";
                    column(ItemDescription; Description) { }
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field("Entry Type"; ItemLedgerEntry."Entry Type")
                    {
                    }
                    field("Document Type"; ItemLedgerEntry."Document Type")
                    {
                    }
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

        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetRange("entry Type", ItemLedgerEntry."entry Type"::Sale);
    end;

    trigger OnPreReport()
    begin
        ItemLedgerFilter := ItemLedgerEntry.GetFilters;
        CompanyInfo.Reset();
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.Get();
    end;

    var
        ItemLedgerFilter: Text[250];
        CompanyInfo: Record "Company Information";
}
