#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 916 "Assembly Order Statistics"
{
    Caption = 'Assembly Order Statistics';
    DataCaptionFields = "No.",Description;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Assembly Header";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                fixed(Control1903895301)
                {
                    group("Standard Cost")
                    {
                        Caption = 'Standard Cost';
                        field(StdMatCost;Value[Colidx::StdCost,Rowidx::MatCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Material Cost';
                            Editable = false;
                        }
                        field(StdResCost;Value[Colidx::StdCost,Rowidx::ResCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Resource Cost';
                            Editable = false;
                        }
                        field(StdResOvhd;Value[Colidx::StdCost,Rowidx::ResOvhd])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Resource Overhead';
                            Editable = false;
                        }
                        field(StdAsmOvhd;Value[Colidx::StdCost,Rowidx::AsmOvhd])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Assembly Overhead';
                            Editable = false;
                        }
                        field(StdTotalCost;Value[Colidx::StdCost,Rowidx::Total])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';
                            Editable = false;
                        }
                    }
                    group("Expected Cost")
                    {
                        Caption = 'Expected Cost';
                        field(ExpMatCost;Value[Colidx::ExpCost,Rowidx::MatCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(ExpResCost;Value[Colidx::ExpCost,Rowidx::ResCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(ExpResOvhd;Value[Colidx::ExpCost,Rowidx::ResOvhd])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(ExpAsmOvhd;Value[Colidx::ExpCost,Rowidx::AsmOvhd])
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies the expected overhead cost of the assembly order.';
                        }
                        field(ExpTotalCost;Value[Colidx::ExpCost,Rowidx::Total])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Actual Cost")
                    {
                        Caption = 'Actual Cost';
                        field(ActMatCost;Value[Colidx::ActCost,Rowidx::MatCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(ActResCost;Value[Colidx::ActCost,Rowidx::ResCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(ActResOvhd;Value[Colidx::ActCost,Rowidx::ResOvhd])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(ActAsmOvhd;Value[Colidx::ActCost,Rowidx::AsmOvhd])
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(ActTotalCost;Value[Colidx::ActCost,Rowidx::Total])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Dev. %")
                    {
                        Caption = 'Dev. %';
                        field(DevMatCost;Value[Colidx::Dev,Rowidx::MatCost])
                        {
                            ApplicationArea = Basic;
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(DevResCost;Value[Colidx::Dev,Rowidx::ResCost])
                        {
                            ApplicationArea = Basic;
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(DevResOvhd;Value[Colidx::Dev,Rowidx::ResOvhd])
                        {
                            ApplicationArea = Basic;
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(DevAsmOvhd;Value[Colidx::Dev,Rowidx::AsmOvhd])
                        {
                            ApplicationArea = Basic;
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(DevTotalCost;Value[Colidx::Dev,Rowidx::Total])
                        {
                            ApplicationArea = Basic;
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group(Variance)
                    {
                        Caption = 'Variance';
                        field(VarMatCost;Value[Colidx::"Var",Rowidx::MatCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(VarResCost;Value[Colidx::"Var",Rowidx::ResCost])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(VarResOvhd;Value[Colidx::"Var",Rowidx::ResOvhd])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(VarAsmOvhd;Value[Colidx::"Var",Rowidx::AsmOvhd])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(VarTotalCost;Value[Colidx::"Var",Rowidx::Total])
                        {
                            ApplicationArea = Basic;
                            AutoFormatType = 1;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CalcStdCost: Codeunit "Calculate Standard Cost";
    begin
        Clear(Value);
        CalcStdCost.CalcAsmOrderStatistics(Rec,Value);
    end;

    var
        Value: array [5,5] of Decimal;
        ColIdx: Option ,StdCost,ExpCost,ActCost,Dev,"Var";
        RowIdx: Option ,MatCost,ResCost,ResOvhd,AsmOvhd,Total;
}

