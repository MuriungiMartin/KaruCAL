#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51081 "Store Issue Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Store Issue Voucher.rdlc';

    dataset
    {
        dataitem(UnknownTable61136;UnknownTable61136)
        {
            RequestFilterFields = No;
            column(ReportForNavId_7683; 7683)
            {
            }
            column(Department;Department)
            {
            }
            column(Internal_Requistion_Header_No;No)
            {
            }
            column(ThisLNAmt;ThisLNAmt)
            {
            }
            column(KARATINAUNIVERSITY1Caption;KARATINAUNIVERSITY1CaptionLbl)
            {
            }
            column(STORE_ISSUE_VOUCHERCaption;STORE_ISSUE_VOUCHERCaptionLbl)
            {
            }
            column(QTY_REQ_DCaption;QTY_REQ_DCaptionLbl)
            {
            }
            column(ITEM_DESCRIPTIONCaption;ITEM_DESCRIPTIONCaptionLbl)
            {
            }
            column(UNITCaption;UNITCaptionLbl)
            {
            }
            column(REQUISITION_NO_Caption;REQUISITION_NO_CaptionLbl)
            {
            }
            column(TO___POINT_OF_USE_Caption;TO___POINT_OF_USE_CaptionLbl)
            {
            }
            column(QTY_ISSUEDCaption;QTY_ISSUEDCaptionLbl)
            {
            }
            column(STOCK_BALANCECaption;STOCK_BALANCECaptionLbl)
            {
            }
            column(NO_Caption;NO_CaptionLbl)
            {
            }
            column(RATECaption;RATECaptionLbl)
            {
            }
            column(VALUECaption;VALUECaptionLbl)
            {
            }
            column(LEDGER_FOLIO_NO_Caption;LEDGER_FOLIO_NO_CaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000027;EmptyStringCaption_Control1000000027Lbl)
            {
            }
            column(AUTHORISED_BYCaption;AUTHORISED_BYCaptionLbl)
            {
            }
            column(Posted_to_stock_Record_byCaption;Posted_to_stock_Record_byCaptionLbl)
            {
            }
            column(SignatureCaption;SignatureCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(DATECaption_Control1000000028;DATECaption_Control1000000028Lbl)
            {
            }
            column(TOTAL_VALUECaption;TOTAL_VALUECaptionLbl)
            {
            }
            column(Issued_byCaption;Issued_byCaptionLbl)
            {
            }
            column(SignatureCaption_Control1000000039;SignatureCaption_Control1000000039Lbl)
            {
            }
            column(DateCaption_Control1000000041;DateCaption_Control1000000041Lbl)
            {
            }
            column(Received_byCaption;Received_byCaptionLbl)
            {
            }
            column(SignatureCaption_Control1000000045;SignatureCaption_Control1000000045Lbl)
            {
            }
            column(DateCaption_Control1000000046;DateCaption_Control1000000046Lbl)
            {
            }
            dataitem(UnknownTable61137;UnknownTable61137)
            {
                DataItemLink = "Requistion No"=field(No);
                DataItemTableView = sorting("Requistion No","Line No.") order(ascending);
                column(ReportForNavId_5319; 5319)
                {
                }
                column(Requistion_Line_Quantity;Quantity)
                {
                }
                column(Requistion_Line_Description;Description)
                {
                }
                column(Requistion_Line__Requistion_Line___Unit_of_Measure_;"PROC-Requistion Line"."Unit of Measure")
                {
                }
                column(RecSeq;RecSeq)
                {
                }
                column(Requistion_Line_Quantity_Control1000000029;Quantity)
                {
                }
                column(Requistion_Line__Unit_Price_;"Unit Price")
                {
                }
                column(Requistion_Line__Line_Amount_;"Line Amount")
                {
                }
                column(Qty_in_store__Quantity;"Qty in store"-Quantity)
                {
                }
                column(Requistion_Line__No__;"No.")
                {
                }
                column(Requistion_Line_Requistion_No;"Requistion No")
                {
                }
                column(Requistion_Line_Line_No_;"Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin


                      ThisLNAmt:=ThisLNAmt+"PROC-Requistion Line"."Line Amount";
                       RecSeq:=RecSeq+1;
                end;

                trigger OnPreDataItem()
                begin

                       "PROC-Requistion Line".SetRange("PROC-Requistion Line".Type,"PROC-Requistion Line".Type::Item);
                        RecSeq:=0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                       Dimvalues.SetRange(Dimvalues.Code,"PROC-Internal Req. Header"."Global Dimension 1 Code");
                        if Dimvalues.Find('-') then
                          Department:=Dimvalues.Name;
                
                     if Vendors.Get("PROC-Internal Req. Header".Supplier) then
                
                    //Get Prev Months Budget, Current Month Budget Per Department
                
                        //Get Budget for the G/L
                      Evaluate(CurrMonth,Format(Date2dmy("Request date",2)));
                      Evaluate(CurrYR,Format(Date2dmy("Request date",3)));
                      Evaluate(BudgetDate,Format('01'+'/'+ CurrMonth +'/'+CurrYR));
                
                      if BudgetDate=0D then
                         Error('Budget Date is Missing');
                      TotalMonthReq:= GetMonthlyTot(BudgetDate,"PROC-Internal Req. Header"."Global Dimension 1 Code");
                
                
                       if GenLedSetup.Get then begin
                       RequisitionLine.SetRange(RequisitionLine."Requistion No","PROC-Internal Req. Header".No);
                       if  RequisitionLine.Find ('-') then begin
                
                          if RequisitionLine.Type=RequisitionLine.Type::"G/L Account" then
                              BudgetGL:=RequisitionLine."No.";
                
                          if RequisitionLine.Type=RequisitionLine.Type::Item then
                            if QtyStore.Get(RequisitionLine."No.") then
                                BudgetGL:=QtyStore."Item G/L Budget Account";
                
                
                         GLAccount.SetFilter(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                         GLAccount.SetRange(GLAccount."Global Dimension 1 Filter","PROC-Internal Req. Header"."Global Dimension 1 Code");
                         GLAccount.SetRange(GLAccount."No.",BudgetGL);
                        /*Get the exact Monthly Budget*/
                         GLAccount.SetRange(GLAccount."Date Filter",BudgetDate);
                         if GLAccount.Find('-') then begin
                         GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                         Budget:=GLAccount."Budgeted Amount";//-GLAccount."Net Change";
                         CurrMonthBud:=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                
                        end;
                        //Previous Month
                        BudgetDate:=CalcDate('-1M',BudgetDate);
                        GLAccount.Reset;
                        GLAccount.SetFilter(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                        GLAccount.SetFilter(GLAccount."Global Dimension 1 Filter","PROC-Internal Req. Header"."Global Dimension 1 Code");
                        GLAccount.SetRange(GLAccount."No.",BudgetGL);
                        GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                        GLAccount.SetRange(GLAccount."Date Filter",BudgetDate);
                        if GLAccount.Find('-') then begin
                         GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                         "BudgetB/F":=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                          TotAvailableBud:=(GLAccount."Budgeted Amount"-GLAccount."Net Change")+CurrMonthBud;
                        end;
                      end;
                     end;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Department: Text[30];
        Dimvalues: Record "Dimension Value";
        Vendors: Record Vendor;
        PrevMonthBud: Decimal;
        CurrMonthBud: Decimal;
        TotAvailableBud: Decimal;
        GLAccount: Record "G/L Account";
        GenLedSetup: Record "General Ledger Setup";
        QtyStore: Record Item;
        GenPostGroup: Record "General Posting Setup";
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        ReqHeader: Record UnknownRecord61136;
        BudgetDate: Date;
        YrBudget: Decimal;
        "BudgetB/F": Decimal;
        RequisitionLine: Record UnknownRecord61137;
        BudgetGL: Code[20];
        ThisLNAmt: Decimal;
        MonthReqHdr: Record UnknownRecord61136;
        PeriodTo: Date;
        MonthReq: Record UnknownRecord61137;
        TotalMonthReq: Decimal;
        RecSeq: Integer;
        KARATINAUNIVERSITY1CaptionLbl: label 'KARATINA UNIVERSITY';
        STORE_ISSUE_VOUCHERCaptionLbl: label 'STORE ISSUE VOUCHER';
        QTY_REQ_DCaptionLbl: label 'QTY REQ''D';
        ITEM_DESCRIPTIONCaptionLbl: label 'ITEM DESCRIPTION';
        UNITCaptionLbl: label 'UNIT';
        REQUISITION_NO_CaptionLbl: label 'REQUISITION NO.';
        TO___POINT_OF_USE_CaptionLbl: label 'TO: (POINT OF USE)';
        QTY_ISSUEDCaptionLbl: label 'QTY ISSUED';
        STOCK_BALANCECaptionLbl: label 'STOCK BALANCE';
        NO_CaptionLbl: label 'NO.';
        RATECaptionLbl: label 'RATE';
        VALUECaptionLbl: label 'VALUE';
        LEDGER_FOLIO_NO_CaptionLbl: label 'LEDGER FOLIO NO.';
        EmptyStringCaptionLbl: label '______________________________________';
        EmptyStringCaption_Control1000000027Lbl: label '________________________________';
        AUTHORISED_BYCaptionLbl: label 'AUTHORISED BY';
        Posted_to_stock_Record_byCaptionLbl: label 'Posted to stock Record by';
        SignatureCaptionLbl: label 'Signature';
        DateCaptionLbl: label 'Date';
        DATECaption_Control1000000028Lbl: label 'DATE';
        TOTAL_VALUECaptionLbl: label 'TOTAL VALUE';
        Issued_byCaptionLbl: label 'Issued by';
        SignatureCaption_Control1000000039Lbl: label 'Signature';
        DateCaption_Control1000000041Lbl: label 'Date';
        Received_byCaptionLbl: label 'Received by';
        SignatureCaption_Control1000000045Lbl: label 'Signature';
        DateCaption_Control1000000046Lbl: label 'Date';


    procedure GetMonthlyTot(var Periodfrom: Date;var Dept: Code[20]) TotMonthReq: Decimal
    begin
        TotMonthReq:=0;
        PeriodTo:=CalcDate('1M',Periodfrom);
        PeriodTo:=CalcDate('-1D',PeriodTo);
        MonthReqHdr.Reset;
        MonthReqHdr.SetRange(MonthReqHdr."Request date",Periodfrom,PeriodTo);
        MonthReqHdr.SetRange(MonthReqHdr."Global Dimension 1 Code",Dept);
        MonthReqHdr.SetRange(MonthReqHdr.Status,MonthReqHdr.Status::Released);
        if MonthReqHdr.Find('-') then begin
           repeat
           MonthReq.Reset;
           MonthReq.SetRange(MonthReq."Requistion No",MonthReqHdr.No);
           if MonthReq.Find('-') then begin
              repeat
              TotMonthReq:=TotMonthReq+MonthReq."Line Amount";
              until MonthReq.Next=0;
           end;
           until MonthReqHdr.Next=0;
        end;
    end;
}

