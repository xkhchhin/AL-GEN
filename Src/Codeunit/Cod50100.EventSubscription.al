codeunit 50100 "CustomWorkflowEvents"
{
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure ItemTrackingLinesOnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        SalesSetup.Get();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckSalesApprovalPossible', '', false, false)]
    local procedure OnSendSalesDocumentforApproval(var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        SalesHeader."Loan Amount" := Customer."Loan Amount";
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;

    //onbeforesaveattachment
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeSaveAttachment', '', false, false)]
    local procedure OnBeforeSaveAttachment(var TempBlob: Codeunit "Temp Blob");
    var
        Msg: Label 'The current size is %1 MB.';
    begin
        Message(Msg, Round(TempBlob.Length() / 1024 / 1024, 0.01, '='));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Inc. Doc. Attachment Overview", 'OnBeforeSaveAttachment', '', false, false)]
    local procedure OnBeforeSaveAttachmentInc(var TempBlob: Codeunit "Temp Blob");
    var
        Msg: Label 'The current size is %1 MB.';
    begin
        Message(Msg, Round(TempBlob.Length() / 1024 / 1024, 0.01, '='));
    end;


    //==================SALE DOCUMENT EVENT SUBSCRIPTION==================//
    //after insert sale line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', false, false)]
    local procedure OnAfterPostSalesShptLine(SalesLine: Record "Sales Line"; var SalesShipmentLine: Record "Sales Shipment Line")
    begin
        SalesShipmentLine.test := SalesLine.test;
    end;
    //after init to item ledger entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnItemJnlPostLineOnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry.OptionType := ItemJournalLine.OptionType;
        NewItemLedgEntry."Student Name" := ItemJournalLine."Student Name";
        NewItemLedgEntry.test := ItemJournalLine.test;
    end;

    //before post to item journal
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeItemJnlPostLine', '', false, false)]
    local procedure OnBeforeItemJnlPostLine(SalesLine: Record "Sales Line"; var ItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine.test := SalesLine.test;
        ItemJournalLine."Student Name" := SalesLine."Student Name";
    end;
    //before post sale shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckPostWhseShptLines', '', false, false)]
    local procedure OnAfterPostSalesShptLines(SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
        SalesShptLine.test := SalesLine.test;
    end;
    //after create warehouse shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnAfterInitNewWhseShptLine', '', false, false)]
    local procedure OnAfterInitNewWhseShptLine(var WhseShptLine: Record "Warehouse Shipment Line"; SalesLine: Record "Sales Line")
    begin
        WhseShptLine.test := SalesLine.test;
    end;
    //after post warehouse shipment to posted whse.shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterInitPostedShptLine', '', false, false)]
    local procedure OnAfterInitPostedShptLine(var WhseShipmentLine: Record "Warehouse Shipment Line"; var PostedWhseShipmentLine: Record "Posted Whse. Shipment Line")
    begin
        PostedWhseShipmentLine.test := WhseShipmentLine.test;
    end;
    //register posted whse ship line to whse Jnl line 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforeRegisterWhseJnlLines', '', false, false)]
    local procedure OnBeforeRegisterWhseJnlLines(var PostedWhseShptLine: Record "Posted Whse. Shipment Line"; var TempWhseJnlLine: Record "Warehouse Journal Line")
    begin
        TempWhseJnlLine.test := PostedWhseShptLine.test;
    end;
    //before register to whse Jnl line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeWhseJnlPostLineRun', '', false, false)]
    local procedure OnBeforeWhseJnlPostLineRun(ItemJournalLine: Record "Item Journal Line"; var TempWarehouseJournalLine: Record "Warehouse Journal Line" temporary)
    begin
        TempWarehouseJournalLine.test := ItemJournalLine.test;
    end;
    //before insert to warehouse entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeInsertWhseEntry', '', false, false)]
    local procedure OnItemJnlPostLineOnAfterInitItemLedgEntry_WHSE(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry.test := WarehouseJournalLine.test;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnAfterInsertWhseEntry', '', false, false)]
    local procedure OnAfterInsertWhseEntryRegisterLine(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry.test := WarehouseJournalLine.test;
    end;
    //==================PURCHASE DOCUMENT EVENT SUBSCRIPTION==================//
    //after insert sale line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        PurchaseLine.test := PurchRcptLine.test;
    end;
    //after init to item ledger entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnItemJnlPostLinePurch(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry.OptionType := ItemJournalLine.OptionType;
        NewItemLedgEntry."Student Name" := ItemJournalLine."Student Name";
        NewItemLedgEntry.test := ItemJournalLine.test;
    end;

    //before post to item journal
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeItemJnlPostLine', '', false, false)]
    local procedure OnBeforeItemJnlPostPurchLine(PurchaseLine: Record "Purchase Line"; var ItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine.test := PurchaseLine.test;
    end;
    //before post sale shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckPurchRcptLine', '', false, false)]
    local procedure OnAfterPostSalesRecitLines(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        PurchRcptLine.test := PurchaseLine.test;
    end;
    //after create warehouse shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnPurchLine2ReceiptLineOnAfterInitNewLine', '', false, false)]
    local procedure OnAfterInitNewWhseRecuiptLine(var WhseReceiptLine: Record "Warehouse Receipt Line"; PurchaseLine: Record "Purchase Line")
    begin
        WhseReceiptLine.test := PurchaseLine.test;
    end;
    //after post warehouse shipment to posted whse.shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterInitPostedRcptLine', '', false, false)]
    local procedure OnAfterInitPostedReceiptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    begin
        PostedWhseReceiptLine.test := WarehouseReceiptLine.test;
    end;
    //register posted whse ship line to whse Jnl line 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeRegisterWhseJnlLines', '', false, false)]
    local procedure OnBeforeRegisterReceiptWhseJnlLines(var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; var TempWarehouseJournalLine: Record "Warehouse Journal Line" temporary)
    begin
        TempWarehouseJournalLine.test := PostedWhseReceiptLine.test;
    end;
    //before insert to warehouse entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeInsertWhseEntry', '', false, false)]
    local procedure OnItemJnlPostLineOnAfterInit(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry.test := WarehouseJournalLine.test;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnAfterInsertWhseEntry', '', false, false)]
    local procedure OnAfterInsertWhseEntry(var WarehouseEntry: Record "Warehouse Entry"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry.test := WarehouseJournalLine.test;
    end;


    procedure ModifyInvoiceNo(PostedInvoiceNo: Code[20]; NewInvoiceNo: Code[20])
    var
        PostedPurchInv: Record "Purch. Inv. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        Confirm: Boolean;
    begin
        // Find the posted purchase invoice by its current number
        if PostedPurchInv.Get(PostedInvoiceNo) then begin
            // Optional: Confirm the action with the user
            Confirm := Confirm(
                'Do you want to change the Posted Purchase Invoice No. from %1 to %2?',
                false,
                PostedInvoiceNo,
                NewInvoiceNo
            );

            if Confirm then begin
                // Check if the new invoice number is already in use
                if PostedPurchInv.Get(NewInvoiceNo) then
                    Error('The new invoice number %1 is already in use.', NewInvoiceNo);

                // Update the No. field
                PostedPurchInv."No." := NewInvoiceNo;
                PostedPurchInv.Modify();

                // If the number is linked to other related records, update them as well
                if PurchInvHeader.Get(PostedInvoiceNo) then begin
                    PurchInvHeader."No." := NewInvoiceNo;
                    PurchInvHeader.Modify();
                end;

                // Optional: Notify the user of success
                Message('The Posted Purchase Invoice No. has been changed from %1 to %2.', PostedInvoiceNo, NewInvoiceNo);
            end;
        end else
            Error('The Posted Purchase Invoice No. %1 could not be found.', PostedInvoiceNo);
    end;

}
