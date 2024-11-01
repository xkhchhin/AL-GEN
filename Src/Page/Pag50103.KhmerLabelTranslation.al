page 50103 KhmerLabelTranslation
{
    ApplicationArea = All;
    Caption = 'Khmer Label Translation';
    PageType = List;
    SourceTable = KhmerLabel;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                    Editable = false;

                }
                field("English Description"; Rec."English Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the English Description field.';
                }
                field("Khmer Description"; Rec."Khmer Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Khmer Description field.';
                }
                field("Label Type"; Rec."Label Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Reload")
            {
                ApplicationArea = All;
                Caption = 'Load Default';
                Image = WorkCenterLoad;
                trigger OnAction()
                begin
                    CreateDefaultCode();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.IsEmpty then
            CreateDefaultCode();
    end;

    local procedure CreateDefaultCode()
    begin
        // KhmerLabel.Reset();
        CreateDefaultCodeandDescription('No', 'No.', 'លេខរៀង');
        CreateDefaultCodeandDescription('ItemNo', 'Item No.', 'លេខកូដទំនិញ');
        CreateDefaultCodeandDescription('Discount', 'Discount', 'បញ្ចុះតំលៃ');
        CreateDefaultCodeandDescription('Picture', 'Picture', 'រូបភាព');
        CreateDefaultCodeandDescription('Description', 'Description', 'បរិយាយ');
        CreateDefaultCodeandDescription('Qty', 'Qty', 'បរិំមាណ');
        CreateDefaultCodeandDescription('UOM', 'UOM', 'ឯកតា');
        CreateDefaultCodeandDescription('Price', 'Price', 'តំលៃ');
        CreateDefaultCodeandDescription('Total', 'Total', 'សរុប');
        CreateDefaultCodeandDescription('Note', 'Note', 'កំណត់សំគាល់');
        CreateDefaultCodeandDescription('Seller', 'Seller', 'អ្នកលក់');
        CreateDefaultCodeandDescription('Buyer', 'Buyer', 'អ្នកទិញ');

    end;

    local procedure CreateDefaultCodeandDescription(LabelCode: Code[24]; EngDesc: Text[50]; KhmerDesc: Text[100])
    var
        KhmerLabel: Record KhmerLabel;
    begin
        KhmerLabel.Reset();
        KhmerLabel.Init();
        KhmerLabel.Code := LabelCode;
        KhmerLabel."English Description" := EngDesc;
        KhmerLabel."Khmer Description" := KhmerDesc;
        KhmerLabel."Label Type" := KhmerLabel."Label Type"::System;
        KhmerLabel.Insert(true);
    end;


    var
        ToCompany: Text;
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelHeaderImportSucess: Label 'Transfer Header with document type Invoice is successfully imported.';
        ExcelLineImportSucess: Label 'Transfer Line with document type Invoice is successfully imported.';
        TransferLineLbl: Label 'Transfer Line';
        TransferHrdLbl: Label 'Transfer Header';
        TransferOrderNo: Code[20];
        ReservationEntry: Record "Reservation Entry";
        KhmerLabel: Record KhmerLabel;
}
