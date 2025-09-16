#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51271 "Store Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Store Requisition.rdlc';

    dataset
    {
        dataitem(UnknownTable61399;UnknownTable61399)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_1826; 1826)
            {
            }
            column(Store_Requistion_Header__No__;"No.")
            {
            }
            column(Store_Requistion_Header__Request_Description_;"Request Description")
            {
            }
            column(Store_Requistion_Header__Request_date_;"Request date")
            {
            }
            column(Store_Requistion_Header__Required_Date_;"Required Date")
            {
            }
            column(Store_Requistion_Header__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(dept;dimVal.Name)
            {
            }
            column(Store_Requistion_Header__Function_Name_;"Function Name")
            {
            }
            column(Store_Requistion_Header__Budget_Center_Name_;"Budget Center Name")
            {
            }
            column(TIME_PRINTED_____FORMAT_TIME_;'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_;'DATE PRINTED:' + Format(Today,0,4))
            {
                AutoFormatType = 1;
            }
            column(USERID;UserId)
            {
            }
            column(pics;info.Picture)
            {
            }
            column(ApprovalUserArr_3_;ApprovalUserArr[3])
            {
            }
            column(ApprovalDateArr_3_;ApprovalDateArr[3])
            {
            }
            column(Store_Requistion_Header__Store_Requistion_Header___Requester_ID_;"PROC-Store Requistion Header"."Requester ID")
            {
            }
            column(Store_RequistionCaption;Store_RequistionCaptionLbl)
            {
            }
            column(Store_Requistion_Header__No__Caption;FieldCaption("No."))
            {
            }
            column(Store_Requistion_Header__Request_Description_Caption;FieldCaption("Request Description"))
            {
            }
            column(Store_Requistion_Header__Request_date_Caption;FieldCaption("Request date"))
            {
            }
            column(Store_Requistion_Header__Required_Date_Caption;FieldCaption("Required Date"))
            {
            }
            column(Store_Requistion_Header__Global_Dimension_1_Code_Caption;FieldCaption("Global Dimension 1 Code"))
            {
            }
            column(Store_Requistion_Header__Shortcut_Dimension_2_Code_Caption;FieldCaption("Shortcut Dimension 2 Code"))
            {
            }
            column(Store_Requistion_Lines__No__Caption;"PROC-Store Requistion Lines".FieldCaption("No."))
            {
            }
            column(Store_Requistion_Lines_DescriptionCaption;"PROC-Store Requistion Lines".FieldCaption(Description))
            {
            }
            column(Store_Requistion_Lines_QuantityCaption;"PROC-Store Requistion Lines".FieldCaption(Quantity))
            {
            }
            column(UoMCaption;UoMCaptionLbl)
            {
            }
            column(Store_Requistion_Lines__Line_Amount_Caption;"PROC-Store Requistion Lines".FieldCaption("Line Amount"))
            {
            }
            column(Store_Requistion_Lines__Unit_Cost_Caption;"PROC-Store Requistion Lines".FieldCaption("Unit Cost"))
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Name_Caption;Name_CaptionLbl)
            {
            }
            column(RecipientCaption;RecipientCaptionLbl)
            {
            }
            column(Printed_By_Caption;Printed_By_CaptionLbl)
            {
            }
            column(Name_Caption_Control1102755052;Name_Caption_Control1102755052Lbl)
            {
            }
            column(Date_Caption_Control1102755053;Date_Caption_Control1102755053Lbl)
            {
            }
            column(Signature_Caption;Signature_CaptionLbl)
            {
            }
            column(AuthorisationsCaption;AuthorisationsCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Signature_Caption_Control1102755000;Signature_Caption_Control1102755000Lbl)
            {
            }
            dataitem(UnknownTable61724;UnknownTable61724)
            {
                DataItemLink = "Requistion No"=field("No.");
                DataItemTableView = sorting("Requistion No","No.") order(ascending);
                column(ReportForNavId_7187; 7187)
                {
                }
                column(seq;seq)
                {
                }
                column(Store_Requistion_Lines__No__;"No.")
                {
                }
                column(Store_Requistion_Lines_Description;Description)
                {
                }
                column(Issued;Quantity)
                {
                }
                column(Requested;"PROC-Store Requistion Lines"."Quantity Requested")
                {
                }
                column(Store_Requistion_Lines__Unit_of_Measure_;"Unit of Measure")
                {
                }
                column(Store_Requistion_Lines__Line_Amount_;"Line Amount")
                {
                }
                column(Store_Requistion_Lines__Unit_Cost_;"Unit Cost")
                {
                }
                column(Store_Requistion_Lines_Requistion_No;"Requistion No")
                {
                }
                column(QtyRequested;"PROC-Store Requistion Lines"."Quantity Requested")
                {
                }

                trigger OnAfterGetRecord()
                begin
                            seq:=seq+1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange(ApprovalEntry."Document No.","PROC-Store Requistion Header"."No.");
                ApprovalEntry.SetRange(ApprovalEntry."Document Type",ApprovalEntry."document type"::Requisition);
                if ApprovalEntry.Find('-') then repeat
                  ApprovalUserArr[ApprovalEntry."Sequence No."]:=ApprovalEntry."Last Modified By ID";
                  ApprovalDateArr[ApprovalEntry."Sequence No."]:=ApprovalEntry."Last Date-Time Modified";
                until ApprovalEntry.Next=0;
                Clear(seq);
                dimVal.Reset;
                dimVal.SetRange(dimVal.Code,"PROC-Store Requistion Header"."Shortcut Dimension 2 Code");
                if dimVal.Find('-') then begin
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

    trigger OnInitReport()
    begin
         info.Reset;
         if info.Find('-') then begin
         info.CalcFields(info.Picture);
         end;
    end;

    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalUserArr: array [40] of Code[30];
        ApprovalDateArr: array [40] of DateTime;
        ArrCount: Integer;
        Store_RequistionCaptionLbl: label 'Store Requistion';
        UoMCaptionLbl: label 'UoM';
        Date_CaptionLbl: label 'Date:';
        Name_CaptionLbl: label 'Name:';
        RecipientCaptionLbl: label 'Recipient';
        Printed_By_CaptionLbl: label 'Printed By:';
        Name_Caption_Control1102755052Lbl: label 'Name:';
        Date_Caption_Control1102755053Lbl: label 'Date:';
        Signature_CaptionLbl: label 'Signature:';
        AuthorisationsCaptionLbl: label 'Authorisations';
        EmptyStringCaptionLbl: label '================================================================================================================================================================================================';
        Signature_Caption_Control1102755000Lbl: label 'Signature:';
        seq: Integer;
        dimVal: Record "Dimension Value";
        info: Record "Company Information";
}

