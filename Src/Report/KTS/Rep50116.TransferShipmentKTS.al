report 50116 TransferShipmentKTS
{
    Caption = 'Transfer Shipment (KTS)';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/KTS/TransferShipment.rdl';

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Posted Transfer Shipment';
            column(UserFullName; TUser."Full Name")
            {
            }
            column(CompanyInfo; CompanyInfo.Picture) { }
            column(TransferOrderNo; "Transfer Shipment Header"."Transfer Order No.")
            {
            }
            column(TransferOrderNoCap; "Transfer Shipment Header".FieldCaption("Transfer Shipment Header"."Transfer Order No."))
            {
            }
            column(No_TransShptHeader; "No.")
            {
            }
            column(No_TransferHdrCap; "Transfer Shipment Header".FieldCaption("No."))
            {
            }
            column(PostingDate_hdr; Format("Transfer Shipment Header"."Posting Date", 0, 4))
            {
            }
            column(PostingDate_hdrCap; "Transfer Shipment Header".FieldCaption("Transfer Shipment Header"."Posting Date"))
            {
            }
            column(ShipmentDate_hdr; Format("Transfer Shipment Header"."Shipment Date", 0, 4))
            {
            }
            column(ShipmentDate_hdrCap; "Transfer Shipment Header".FieldCaption("Transfer Shipment Header"."Shipment Date"))
            {
            }
            column(ReceiptDate_hdr; Format("Transfer Shipment Header"."Receipt Date", 0, 4))
            {
            }
            column(ReceiptDate_hdrCap; "Transfer Shipment Header".FieldCaption("Transfer Shipment Header"."Receipt Date"))
            {
            }
            column(ExternalDocumentNo; "Transfer Shipment Header"."External Document No.")
            {
            }
            column(ExternalDocumentNoCap; "Transfer Shipment Header".FieldCaption("Transfer Shipment Header"."External Document No."))
            {
            }
            column(TransferFromCap; TransferFromCap)
            {
            }
            column(TransferToCap; TransferToCap)
            {
            }
            column(UOMCaption; UOMCaption)
            {
            }
            column(BarcodeImage; CompanyInfo.Picture)
            {
            }
            column(PrintBarcode; PrintBarcode)
            {
            }
            column(TransferOrderNoCaptionTranslated; TransferOrderNoCaptionTranslated)
            {
            }
            column(PostingDateCaptionTranslated; PostingDateCaptionTranslated)
            {
            }
            column(ShipmentDateCaptionTranslated; ShipmentDateCaptionTranslated)
            {
            }
            column(ExternalDocumentNoCaptionTranslated; ExternalDocumentNoCaptionTranslated)
            {
            }
            column(ShipmentMethodCaptionTranslated; ShipmentMethodCaptionTranslated)
            {
            }
            column(IntransitCodeCaptionTranslated; IntransitCodeCaptionTranslated)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CopyTextCaption; StrSubstNo(Text001, CopyText))
                    {
                    }
                    column(TransferToAddr1; TransferToAddr[1])
                    {
                    }
                    column(TransferFromAddr1; TransferFromAddr[1])
                    {
                    }
                    column(TransferToAddr2; TransferToAddr[2])
                    {
                    }
                    column(TransferFromAddr2; TransferFromAddr[2])
                    {
                    }
                    column(TransferToAddr3; TransferToAddr[3])
                    {
                    }
                    column(TransferFromAddr3; TransferFromAddr[3])
                    {
                    }
                    column(TransferToAddr4; TransferToAddr[4])
                    {
                    }
                    column(TransferFromAddr4; TransferFromAddr[4])
                    {
                    }
                    column(TransferToAddr5; TransferToAddr[5])
                    {
                    }
                    column(TransferToAddr6; TransferToAddr[6])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoPhoneNoCap; CompanyInfo.FieldCaption(CompanyInfo."Phone No."))
                    {
                    }
                    column(CompanyInfoHomePageCap; CompanyInfo.FieldCaption(CompanyInfo."Home Page"))
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoEmailCap; CompanyInfo.FieldCaption(CompanyInfo."E-Mail"))
                    {
                    }
                    column(CompanyInfoName; CompanyInfo.Name)
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankNameCap; CompanyInfo.FieldCaption(CompanyInfo."Bank Name"))
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CompanyInfoBankBranchNo; CompanyInfo."Bank Branch No.")
                    {
                    }
                    column(CompanyInfoSwiftCode; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(QuantityCaption; QuantityCaptionLbl)
                    {
                    }
                    column(DescriptionCaption; DescriptionCaptionLbl)
                    {
                    }
                    column(UnitofMeasureCaption; UnitofMeasureCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccountNoCap; CompanyInfo.FieldCaption(CompanyInfo."Bank Account No."))
                    {
                    }
                    column(InTransit_TransShptHeader; "Transfer Shipment Header"."In-Transit Code")
                    {
                        IncludeCaption = true;
                    }
                    column(PostDate_TransShptHeader; Format("Transfer Shipment Header"."Posting Date", 0, 4))
                    {
                    }
                    column(No2_TransShptHeader; "Transfer Shipment Header"."No.")
                    {
                    }
                    column(TransferToAddr7; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr8; TransferToAddr[8])
                    {
                    }
                    column(TransferFromAddr5; TransferFromAddr[5])
                    {
                    }
                    column(TransferFromAddr6; TransferFromAddr[6])
                    {
                    }
                    column(ShiptDate_TransShptHeader; Format("Transfer Shipment Header"."Shipment Date"))
                    {
                    }
                    column(TransferFromAddr7; TransferFromAddr[7])
                    {
                    }
                    column(TransferFromAddr8; TransferFromAddr[8])
                    {
                    }
                    column(PageCaption; StrSubstNo(Text002, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(Desc_ShptMethod; ShipmentMethod.Description)
                    {
                    }
                    column(TransShptHdrNoCaption; TransShptHdrNoCaptionLbl)
                    {
                    }
                    column(TransShptShptDateCaption; TransShptShptDateCaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Transfer Shipment Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number_DimensionLoop1; Number)
                        {
                        }
                        column(HdrDimCaption; HdrDimCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Transfer Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }

                        column(NoOfCopies; NoOfCopies)
                        {
                        }

                        column(ItemNo_TransShptLine; "Item No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Desc_TransShptLine; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(Qty_TransShptLine; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(UOM_TransShptLine; "Unit of Measure")
                        {
                            IncludeCaption = true;
                        }
                        column(LineNo_TransShptLine; "Line No.")
                        {
                        }
                        column(DocNo_TransShptLine; "Document No.")
                        {
                        }
                        column(ItemTrackingSpec_LotNo_; TempItemLedgEntry."Lot No.") { }
                        column(ItemTrackingSpec_ExpirationDate; TempItemLedgEntry."Expiration Date") { }

                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText4; DimText)
                            {
                            }
                            column(Number_DimensionLoop2; Number)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");
                            RetrieveItemLedgFromPurchRcptLine(TempItemLedgEntry, "Transfer Shipment Line");
                        end;

                        trigger OnPostDataItem()
                        begin
                            if ShowLotSN then begin
                                //XTR
                                //ItemTrackingMgt.SetRetrieveAsmItemTracking(TRUE);
                                //TrackingSpecCount := ItemTrackingMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,"Transfer Shipment Header"."No.",
                                //DATABASE::"Transfer Shipment Header",0);
                                //ItemTrackingMgt.SetRetrieveAsmItemTracking(FALSE);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("Item No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(ItemTrackingLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(TrackingSpecBufferItemNo; TrackingSpecBuffer."Item No.")
                        {
                        }
                        column(TrackingSpecBufferDescription; TrackingSpecBuffer.Description)
                        {
                        }
                        column(TrackingSpecBufferLotNo; TrackingSpecBuffer."Lot No.")
                        {
                        }

                        column(TrackingSpecBufferSerialNo; TrackingSpecBuffer."Serial No.")
                        {
                        }
                        column(TrackingSpecBufferQuantity; TrackingSpecBuffer."Quantity (Base)")
                        {
                        }
                        column(ShowTotal; ShowTotal)
                        {
                        }
                        column(ShowGroup; ShowGroup)
                        {
                        }
                        column(SerialNoCaption; SerialNoCaptionLbl)
                        {
                        }
                        column(LotNoCaption; LotNoCaptionLbl)
                        {
                        }
                        column(NoCaption; NoCaptionLbl)
                        {
                        }
                        dataitem(TotalItemTracking; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                            column(TotalQuantity; TotalQty)
                            {
                            }

                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                TrackingSpecBuffer.FindSet
                            else
                                TrackingSpecBuffer.Next;

                            ShowTotal := false;
                            if ItemTrackingAppendix.IsStartNewGroup(TrackingSpecBuffer) then
                                ShowTotal := true;

                            ShowGroup := false;
                            if (TrackingSpecBuffer."Source Ref. No." <> OldRefNo) or
                               (TrackingSpecBuffer."Item No." <> OldNo)
                            then begin
                                OldRefNo := TrackingSpecBuffer."Source Ref. No.";
                                OldNo := TrackingSpecBuffer."Item No.";
                                TotalQty := 0;
                            end else
                                ShowGroup := true;
                            TotalQty += TrackingSpecBuffer."Quantity (Base)";
                        end;

                        trigger OnPreDataItem()
                        begin
                            if TrackingSpecCount = 0 then
                                CurrReport.Break;
                            //CurrReport.NewPage;
                            SetRange(Number, 1, TrackingSpecCount);
                            TrackingSpecBuffer.SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
                              "Source Prod. Order Line", "Source Ref. No.");
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text000;
                        OutputNo += 1;
                    end;
                    // CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                FormatAddr.TransferShptTransferFrom(TransferFromAddr, "Transfer Shipment Header");
                FormatAddr.TransferShptTransferTo(TransferToAddr, "Transfer Shipment Header");

                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init;


                /*//BarCode ++
                IF Barcode.COUNT <= 0 THEN BEGIN
                  Barcode.GetDefault;
                END;
                
                Barcode.FINDFIRST;
                Barcode.SETFILTER(Value,"No.");
                IF Barcode.FIND('-') THEN BEGIN
                  Barcode.CALCFIELDS(Image);
                END
                ELSE BEGIN
                  IF Barcode2.FINDFIRST THEN BEGIN
                     Barcode.INIT;
                     Barcode."Primary Key" := CREATEGUID;
                     Barcode.Value := "No.";
                     Barcode.Type := Barcode2.Type;
                     Barcode.Width := Barcode2.Width;
                     Barcode.Height := Barcode2.Height;
                     Barcode."Include Text" := Barcode2."Include Text";
                     Barcode.Border := Barcode2.Border;
                     Barcode."Reverse Colors" := Barcode2."Reverse Colors";
                     Barcode."ECC Level" := Barcode2."ECC Level";
                     Barcode.Size := Barcode2.Size;
                     Barcode."Image Type" := Barcode2."Image Type";
                     Barcode.INSERT;
                  END;
                  Barcode.GenerateBarCode;
                END;
                
                Barcode.GenerateBarCode();
                
                IF PrintBarcode = FALSE THEN BEGIN
                 CLEAR(Barcode.Image);
                END;
                *///BarCode --\

            end;

            trigger OnPreDataItem()
            begin
                HeaderCaptionTranslate();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(ShowLotSN; ShowLotSN)
                    {
                        Caption = 'Show Serial/Lot Number Appendix';
                    }
                    field(PrintBarcode; PrintBarcode)
                    {
                        Caption = 'Print Barcode';
                        Visible = false;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PostingDateCaption = 'Posting Date';
        ShptMethodCaption = 'Shipment Method';
    }

    trigger OnInitReport()
    begin
        SalesSetup.Get;
        //XKH Add Company Logo
        CompanyInfo.SETAUTOCALCFIELDS(Picture);
        CompanyInfo.GET;
        // CompanyInfo.VerifyAndSetPaymentInfo;
        //XKH Add Company Logo 

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    trigger OnPreReport()
    begin
        //XKH get user full name++
        TUser.Reset;
        TUser.SetRange("User Name", UserId);
        if TUser.Find('-') then;
        //XKH get user full name--
    end;

    var
        Text000: Label ' Copy';
        Text001: Label 'Transfer Shipment%1';
        Text002: Label 'Page %1';
        ShipmentMethod: Record "Shipment Method";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        FormatAddr: Codeunit "Format Address";
        TransferFromAddr: array[8] of Text[50];
        TransferToAddr: array[8] of Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        OutputNo: Integer;
        TransShptHdrNoCaptionLbl: Label 'Shipment No.';
        TransShptShptDateCaptionLbl: Label 'Shipment Date';
        HdrDimCaptionLbl: Label 'Header Dimensions';
        LineDimCaptionLbl: Label 'Line Dimensions';
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        TransferFromCap: Label 'Transfer-from ';
        TransferToCap: Label 'Transfer-to ';
        UOMCaption: Label 'UOM';
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        TrackingSpecCount: Integer;
        Quantity_itemtracking: Integer;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        OldRefNo: Integer;
        OldNo: Code[20];
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingAppendixCaptionLbl: Label 'Item Tracking - Appendix';
        SerialNoCaptionLbl: Label 'Serial No.';
        LotNoCaptionLbl: Label 'Lot No.';
        NoCaptionLbl: Label 'No.';
        QuantityCaptionLbl: Label 'Quantity';
        DescriptionCaptionLbl: Label 'Description';
        UnitofMeasureCaptionLbl: Label 'Unit of Measure';
        PrintBarcode: Boolean;
        "===========the=================": Integer;
        TranslateCaption: Text[30];
        TransferOrderNoCaptionTranslated: Text;
        PostingDateCaptionTranslated: Text;
        ShipmentDateCaptionTranslated: Text;
        ExternalDocumentNoCaptionTranslated: Text;
        ShipmentMethodCaptionTranslated: Text;
        IntransitCodeCaptionTranslated: Text;
        TUser: Record User;

    [Scope('OnPrem')]
    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean; NewShowLotSN: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ShowLotSN := NewShowLotSN;
    end;

    local procedure HeaderCaptionTranslate()
    begin

    end;

    local procedure RetrieveItemLedgFromPurchRcptLine(var TempItemLedg: Record "Item Ledger Entry" temporary; TransferShipmentLine: Record "Transfer Shipment Line")
    var
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
    begin
        TempItemLedg.Reset;
        TempItemLedg.DeleteAll;
        Clear(TempItemLedg);

        ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(
                                TempItemLedg,
                                DATABASE::"Transfer Shipment Line",
                                0,
                                TransferShipmentLine."Document No.",
                                '',
                                0,
                                TransferShipmentLine."Line No.");
        if TempItemLedg.FindFirst then;
    end;
}
