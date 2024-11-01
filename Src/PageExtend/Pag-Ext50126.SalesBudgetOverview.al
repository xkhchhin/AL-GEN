pageextension 50126 "Sales Budget Overview" extends "Sales Budget Overview"
{
    layout
    {
        addlast(Filters)
        {
            field(ItemCategoryFilter1; ItemCategoryFilter1)
            {
                ApplicationArea = SalesBudget;
                Caption = 'Item Category Filter';
                ToolTip = 'Specifies which items category to include in the budget overview.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemList: Page "Item Categories";
                begin
                    ItemList.LookupMode(true);
                    if ItemList.RunModal = ACTION::LookupOK then begin
                        Text := ItemList.GetSelectionFilter;
                        exit(true);
                    end;
                end;

                trigger OnValidate()
                var
                    item: Record Item;
                    salebudget: Page "Sales Budget Overview";
                    itemcat: Record "Item Category";
                    DimensionCodeBuffer: Record "Dimension Code Buffer";
                begin
                end;
            }
        }
    }
    local procedure ItemCategoryFilter1OnAfterValidate()
    begin
        if ColumnDimType = ColumnDimType::Item then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubForm();
    end;

    local procedure UpdateMatrixSubForm()
    begin
        // CurrPage.MATRIX.PAGE.SetFilters(
        //   ItemCategoryFilter1);
        // CurrPage.MATRIX.PAGE.LoadMatrix(
        //   MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns,
        //   CurrentBudgetName, LineDimType, ColumnDimType, RoundingFactor, ValueType, PeriodType);
        // CurrPage.Update(false);
    end;

    local procedure GenerateColumnCaptions(StepType: Enum "Matrix Page Step Type")
    var
        MATRIX_PeriodRecords: array[32] of Record Date;
        Location: Record Location;
        Item: Record "Item Category";
        Customer: Record Customer;
        Vendor: Record Vendor;
        MatrixMgt: Codeunit "Matrix Management";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        i: Integer;
    begin
        Clear(MATRIX_CaptionSet);
        Clear(MATRIX_MatrixRecords);
        FirstColumn := '';
        LastColumn := '';
        MATRIX_CurrentNoOfColumns := 12;

        if ColumnDimCode = '' then
            exit;

        case ColumnDimCode of
            Item.TableCaption:
                begin
                    Clear(MATRIX_CaptionSet);
                    RecRef.GetTable(Item);
                    RecRef.SetTable(Item);
                    if ItemCategoryFilter1 <> '' then begin
                        FieldRef := RecRef.Field(Item.FieldNo(Code));
                        FieldRef.SetFilter(ItemCategoryFilter1);
                    end;
                    MatrixMgt.GenerateMatrixData(
                      RecRef, StepType.AsInteger(), 12, 1,
                      MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                    for i := 1 to MATRIX_CurrentNoOfColumns do
                        MATRIX_MatrixRecords[i].Code := MATRIX_CaptionSet[i];
                    if ShowColumnName then
                        MatrixMgt.GenerateMatrixData(
                          RecRef, "Matrix Page Step Type"::Same.AsInteger(), 12, 3,
                          MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                end;
        end;
    end;

    var
        ItemCategoryFilter1: Text;
        BudgetRecordRef: RecordRef;
        ColumnDimType: Enum "Item Budget Dimension Type";
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_MatrixRecords: array[32] of Record "Dimension Code Buffer";
        FirstColumn: Text;
        LastColumn: Text;
        MATRIX_CurrentNoOfColumns: Integer;
        ColumnDimCode: Text[30];
        MATRIX_PrimKeyFirstCaptionInCu: Text;
        MATRIX_CaptionRange: Text;
        ShowColumnName: Boolean;
}
