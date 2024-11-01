report 50127 "Create Transfer Order"
{
    ApplicationArea = all;
    Caption = 'Create Transfer Order (XKH)';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            RequestFilterFields = "Entry No.", "Posting Date", "Expiration Date", "Item Category Code", "Item No.";
            column(PostingDate; "Posting Date")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(ExpirationDate; "Expiration Date")
            {
            }
            column(RemainingQuantity; "Remaining Quantity")
            {
            }
            column(LotNo; "Lot No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            trigger OnAfterGetRecord()
            begin
                CreateTransferOrder();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(UsingReclassJournal; UsingReclassJournal)
                    {
                        Caption = 'Reclass. Journal';
                        ApplicationArea = All;
                        Editable = UsingTransferOrder = false;
                        trigger OnValidate()
                        begin
                            if UsingReclassJournal = true then
                                UsingTransferOrder := false
                            else
                                UsingTransferOrder := true;
                        end;
                    }
                    field(UsingTransferOrder; UsingTransferOrder)
                    {
                        Caption = 'Transfer Order';
                        Editable = UsingReclassJournal = false;
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if UsingTransferOrder = false then
                                UsingReclassJournal := true
                            else
                                UsingReclassJournal := false;
                        end;

                    }
                    field(TransferFromLocation; TransferFromLocation)
                    {
                        ApplicationArea = All;
                        Caption = 'From Location';
                        TableRelation = Location.Code where("Use As In-Transit" = filter(false));
                    }
                    field(ToLocation; ToLocation)
                    {
                        Caption = 'To Location';
                        ShowMandatory = true;
                        ApplicationArea = All;
                        TableRelation = Location.Code where("Use As In-Transit" = filter(false));
                    }
                    field(IntransitLocation; IntransitLocation)
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                        Caption = 'In-Transit';
                        TableRelation = Location.Code where("Use As In-Transit" = filter(true));
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
    trigger OnInitReport()
    begin
        UsingReclassJournal := true;
        UsingTransferOrder := false;
    end;

    trigger OnPreReport()
    begin
    end;

    trigger OnPostReport()
    begin
    end;

    procedure CreateTransferOrder()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        ItemRec: Record Item;
        NextLineNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentNo: code[20];
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
    begin
        // Initialize Transfer Header

        TransferHeader.Reset();
        TransferHeader.InitRecord();
        TransferHeader."Posting Date" := WorkDate;
        TransferHeader."Transfer-from Code" := TransferFromLocation;
        TransferHeader."Transfer-to Code" := ToLocation; // Specify a new location
        TransferHeader."In-Transit Code" := IntransitLocation;
        TransferHeader.Insert(true);
        TransferHeader.Validate("Transfer-from Code", TransferFromLocation);
        TransferHeader.Validate("Transfer-to Code", ToLocation);
        TransferHeader.Validate("In-Transit Code", IntransitLocation);
        TransferHeader.Modify(true);
        if ItemLedgerEntry.FindSet() then
            repeat
                // Set initial Line No.
                NextLineNo := 0;
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", TransferHeader."No.");
                if TransferLine.FindLast() then
                    NextLineNo := NextLineNo + TransferLine."Line No."
                else
                    NextLineNo := 10000;
                TransferLine.Reset();
                TransferLine.Init();
                //ItemLedgerEntry.SetAutoCalcFields("Remaining Quantity");
                TransferLine."Document No." := TransferHeader."No.";
                TransferLine."Line No." := NextLineNo;  // Set Line No.
                TransferLine."Item No." := ItemLedgEntry."Item No.";
                TransferLine."Transfer-from Code" := TransferHeader."Transfer-from Code";
                TransferLine."Transfer-to Code" := TransferHeader."Transfer-to Code";
                TransferLine.Quantity := ItemLedgEntry."Remaining Quantity";
                TransferLine."Unit of Measure Code" := ItemLedgEntry."Unit of Measure Code";
                TransferLine.Insert(true);
                TransferLine.Validate("Item No.", ItemLedgerEntry."Item No.");
                TransferLine.Validate(Quantity, ItemLedgerEntry."Remaining Quantity");
                TransferLine.Modify(true);
            // Message('Transfer-from code %1.', TransferFromLocation);
            // Message('Transfer-to code %1.', TransferHeader."Transfer-to Code");
            until ItemLedgerEntry.Next() = 0;
        Message('Transfer Order %1 created successfully.', TransferHeader."No.");
    end;

    procedure PrerequisitInfo(FromLocationCode: Code[20])
    begin
        TransferFromLocation := FromLocationCode;
    end;

    var
        TransferFromLocation: Code[20];
        [InDataSet]
        UsingReclassJournal: Boolean;
        [InDataSet]
        UsingTransferOrder: Boolean;
        //FromLocation: Code[50];
        ToLocation: Code[50];
        IntransitLocation: Code[50];
        OpenTransferOrderMessage: Label 'The transfer order is create as number %1 and moved to the Transfer Orders window.\\Do you want to open the transfer Order?', Comment = '%1 = document number';
}
