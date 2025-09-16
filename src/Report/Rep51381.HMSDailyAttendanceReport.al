#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51381 "HMS Daily Attendance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Daily Attendance Report.rdlc';

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..31));
            RequestFilterFields = Number;
            column(ReportForNavId_5444; 5444)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Records_of_daily_attendance_for_the_month_of____FORMAT_Month_;'Records of daily attendance for the month of ' +Format(Month))
            {
            }
            column(stfMsn;stfMsn)
            {
            }
            column(dtDate;dtDate)
            {
            }
            column(dpnMsn;dpnMsn)
            {
            }
            column(stfKsm;stfKsm)
            {
            }
            column(stuMsn;stuMsn)
            {
            }
            column(dpnKsm;dpnKsm)
            {
            }
            column(othMsn;othMsn)
            {
            }
            column(stuKsm;stuKsm)
            {
            }
            column(stfMsn___dpnMsn___stuMsn___othMsn;stfMsn + dpnMsn + stuMsn + othMsn)
            {
            }
            column(othKsm;othKsm)
            {
            }
            column(stfKsm___dpnKsm___stuKsm___othKsm;stfKsm + dpnKsm + stuKsm + othKsm)
            {
            }
            column(GstfMsn;GstfMsn)
            {
            }
            column(GstfKsm;GstfKsm)
            {
            }
            column(GdpnMsn;GdpnMsn)
            {
            }
            column(GdpnKsm;GdpnKsm)
            {
            }
            column(GstuMsn;GstuMsn)
            {
            }
            column(GstuKsm;GstuKsm)
            {
            }
            column(GothMsn;GothMsn)
            {
            }
            column(GstuKsm_Control1102760067;GstuKsm)
            {
            }
            column(GstfMsn___GdpnMsn___GstuMsn___GothMsn;GstfMsn + GdpnMsn + GstuMsn + GothMsn)
            {
            }
            column(GstfKsm___GdpnKsm___GstuKsm___GothKsm;GstfKsm + GdpnKsm + GstuKsm + GothKsm)
            {
            }
            column(USERID;UserId)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(GstfMsn___GdpnMsn___GstuMsn___GothMsn__UpperLimit;(GstfMsn + GdpnMsn + GstuMsn + GothMsn)/UpperLimit)
            {
            }
            column(GstfKsm___GdpnKsm___GstuKsm___GothKsm__UpperLimit;(GstfKsm + GdpnKsm + GstuKsm + GothKsm)/UpperLimit)
            {
            }
            column(GstfMsn___GdpnMsn___GstuMsn___GothMsn__GstfKsm___GdpnKsm___GstuKsm___GothKsm__UpperLimit;(GstfMsn + GdpnMsn + GstuMsn + GothMsn +GstfKsm + GdpnKsm + GstuKsm + GothKsm)/UpperLimit)
            {
            }
            column(HEALTH_SERVICESCaption;HEALTH_SERVICESCaptionLbl)
            {
            }
            column(DATECaption;DATECaptionLbl)
            {
            }
            column(MAINCaption;MAINCaptionLbl)
            {
            }
            column(OTHERCaption;OTHERCaptionLbl)
            {
            }
            column(MAINCaption_Control1102760007;MAINCaption_Control1102760007Lbl)
            {
            }
            column(OTHERCaption_Control1102760008;OTHERCaption_Control1102760008Lbl)
            {
            }
            column(MAINCaption_Control1102760009;MAINCaption_Control1102760009Lbl)
            {
            }
            column(OTHERCaption_Control1102760010;OTHERCaption_Control1102760010Lbl)
            {
            }
            column(MAINCaption_Control1102760011;MAINCaption_Control1102760011Lbl)
            {
            }
            column(OTHERCaption_Control1102760012;OTHERCaption_Control1102760012Lbl)
            {
            }
            column(MAINCaption_Control1102760013;MAINCaption_Control1102760013Lbl)
            {
            }
            column(MAINCaption_Control1102760014;MAINCaption_Control1102760014Lbl)
            {
            }
            column(STAFFCaption;STAFFCaptionLbl)
            {
            }
            column(DEPENDANTCaption;DEPENDANTCaptionLbl)
            {
            }
            column(STUDENTCaption;STUDENTCaptionLbl)
            {
            }
            column(OTHERSCaption;OTHERSCaptionLbl)
            {
            }
            column(TOTALCaption;TOTALCaptionLbl)
            {
            }
            column(TOTALCaption_Control1102760059;TOTALCaption_Control1102760059Lbl)
            {
            }
            column(Source__OP_Registers__OTHER___MAIN_Caption;Source__OP_Registers__OTHER___MAIN_CaptionLbl)
            {
            }
            column(Compiled_by_Caption;Compiled_by_CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Av__Daily_Attendance_OTHER_Caption;Av__Daily_Attendance_OTHER_CaptionLbl)
            {
            }
            column(Av__Daily_Attendance_MAIN_Caption;Av__Daily_Attendance_MAIN_CaptionLbl)
            {
            }
            column(Av__Daily_Attendance__OTHER___MAIN__Caption;Av__Daily_Attendance__OTHER___MAIN__CaptionLbl)
            {
            }
            column(Integer_Number;Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*Reset the values as required*/
                /*Check if the upper limit has been reached*/
                if UpperLimit < Number then begin exit end;
                dtDate:=Dmy2date(Number,IntMonth,Year);
                
                /*Get the number of staff members in maseno*/
                Treatment.Reset;
                //Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::Nyeri);
                Treatment.SetRange(Treatment."Treatment Type",Treatment."treatment type"::Outpatient);
                Treatment.SetRange(Treatment."Treatment Date",dtDate);
                Treatment.SetRange(Treatment."Patient Type",Treatment."patient type"::Student);
                Treatment.SetRange(Treatment.Status,Treatment.Status::Completed);
                stfMsn:=Treatment.Count;
                GstfMsn:=GstfMsn + stfMsn;
                
                Treatment.Reset;
                //Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::Nyeri);
                Treatment.SetRange(Treatment."Treatment Type",Treatment."treatment type"::Outpatient);
                Treatment.SetRange(Treatment."Treatment Date",dtDate);
                Treatment.SetRange(Treatment."Patient Type",Treatment."patient type"::Employee);
                Treatment.SetRange(Treatment.Status,Treatment.Status::Completed);
                dpnMsn:=Treatment.Count;
                GdpnMsn:=GdpnMsn + dpnMsn;
                
                Treatment.Reset;
                //Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::Nyeri);
                //Treatment.SETRANGE(Treatment."Treatment Type",Treatment."Treatment Type"::Outpatient);
                Treatment.SetRange(Treatment."Treatment Date",dtDate);
                Treatment.SetRange(Treatment."Patient Type",Treatment."patient type"::Others);
                Treatment.SetRange(Treatment.Status,Treatment.Status::Completed);
                stuMsn:=Treatment.Count;
                GstuMsn:=GstuMsn + stuMsn;
                
                Treatment.Reset;
                //Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::Nyeri);
                Treatment.SetRange(Treatment."Treatment Type",Treatment."treatment type"::Outpatient);
                Treatment.SetRange(Treatment."Treatment Date",dtDate);
                Treatment.SetRange(Treatment."Patient Type",Treatment."patient type"::" ");
                Treatment.SetRange(Treatment.Status,Treatment.Status::Completed);
                othMsn:=Treatment.Count;
                GothMsn:=GothMsn + othMsn;
                 /*
                {Get the details for kisumu}
                Treatment.RESET;
                Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::"1");
                Treatment.SETRANGE(Treatment."Treatment Type",Treatment."Treatment Type"::Outpatient);
                Treatment.SETRANGE(Treatment."Treatment Date",dtDate);
                Treatment.SETRANGE(Treatment."Patient Type",Treatment."Patient Type"::Employee);
                stfKsm:=Treatment.COUNT;
                GstfKsm :=GstfKsm + stfKsm;
                
                Treatment.RESET;
                Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::"1");
                Treatment.SETRANGE(Treatment."Treatment Type",Treatment."Treatment Type"::Outpatient);
                Treatment.SETRANGE(Treatment."Treatment Date",dtDate);
                Treatment.SETRANGE(Treatment."Patient Type",Treatment."Patient Type"::Relative);
                dpnKsm:=Treatment.COUNT;
                GdpnKsm:=GdpnKsm + dpnKsm;
                
                Treatment.RESET;
                Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::"1");
                Treatment.SETRANGE(Treatment."Treatment Type",Treatment."Treatment Type"::Outpatient);
                Treatment.SETRANGE(Treatment."Treatment Date",dtDate);
                Treatment.SETRANGE(Treatment."Patient Type",Treatment."Patient Type"::Student);
                stuKsm:=Treatment.COUNT;
                GstuKsm:=GstuKsm + stuKsm;
                
                Treatment.RESET;
                Treatment.SETRANGE(Treatment."Treatment Location",Treatment."Treatment Location"::"1");
                Treatment.SETRANGE(Treatment."Treatment Type",Treatment."Treatment Type"::Outpatient);
                Treatment.SETRANGE(Treatment."Treatment Date",dtDate);
                Treatment.SETRANGE(Treatment."Patient Type",Treatment."Patient Type"::Others);
                othKsm:=Treatment.COUNT;
                GothKsm:=GothKsm + othKsm;
                 */

            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Number);
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
        Year:=Date2dmy(Today,3);
    end;

    trigger OnPreReport()
    begin
        /*Check the month that the user has selected*/
        if Month=Month::January then
          begin
            IntMonth:=1;
          end
        else if Month=Month::February then
          begin
            IntMonth:=2;
          end
        else if Month=Month::March then
          begin
            IntMonth:=3;
          end
        else if Month=Month::April then
          begin
            IntMonth:=4;
          end
        else if Month=Month::May then
          begin
            IntMonth:=5;
          end
        else if Month=Month::June then
          begin
            IntMonth:=6;
          end
        else if Month=Month::July then
          begin
            IntMonth:=7;
          end
        else if Month=Month::August then
          begin
            IntMonth:=8;
          end
        else if Month=Month::September then
          begin
            IntMonth:=9;
          end
        else if Month=Month::October then
          begin
            IntMonth:=10;
          end
        else if Month=Month::November then
          begin
            IntMonth:=11;
          end
        else if Month=Month::December then
          begin
            IntMonth:=12;
          end;
        /*Determine the upper limit*/
        UpperLimit:=HRDates.DetermineDaysInMonth(IntMonth,Year);

    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Month: Option January,February,March,April,May,June,July,August,September,October,November,December;
        IntMonth: Integer;
        Year: Integer;
        UpperLimit: Integer;
        HRDates: Codeunit "HR Dates";
        dtDate: Date;
        stfMsn: Integer;
        stfKsm: Integer;
        dpnMsn: Integer;
        dpnKsm: Integer;
        stuMsn: Integer;
        stuKsm: Integer;
        othMsn: Integer;
        othKsm: Integer;
        Treatment: Record UnknownRecord61407;
        GstfMsn: Integer;
        GstfKsm: Integer;
        GdpnMsn: Integer;
        GdpnKsm: Integer;
        GstuMsn: Integer;
        GstuKsm: Integer;
        GothMsn: Integer;
        GothKsm: Integer;
        HEALTH_SERVICESCaptionLbl: label 'HEALTH SERVICES';
        DATECaptionLbl: label 'DATE';
        MAINCaptionLbl: label 'MAIN';
        OTHERCaptionLbl: label 'OTHER';
        MAINCaption_Control1102760007Lbl: label 'MAIN';
        OTHERCaption_Control1102760008Lbl: label 'OTHER';
        MAINCaption_Control1102760009Lbl: label 'MAIN';
        OTHERCaption_Control1102760010Lbl: label 'OTHER';
        MAINCaption_Control1102760011Lbl: label 'MAIN';
        OTHERCaption_Control1102760012Lbl: label 'OTHER';
        MAINCaption_Control1102760013Lbl: label 'MAIN';
        MAINCaption_Control1102760014Lbl: label 'MAIN';
        STAFFCaptionLbl: label 'STAFF';
        DEPENDANTCaptionLbl: label 'DEPENDANT';
        STUDENTCaptionLbl: label 'STUDENT';
        OTHERSCaptionLbl: label 'OTHERS';
        TOTALCaptionLbl: label 'TOTAL';
        TOTALCaption_Control1102760059Lbl: label 'TOTAL';
        Source__OP_Registers__OTHER___MAIN_CaptionLbl: label 'Source: OP Registers (OTHER + MAIN)';
        Compiled_by_CaptionLbl: label 'Compiled by:';
        Date_CaptionLbl: label 'Date:';
        Av__Daily_Attendance_OTHER_CaptionLbl: label 'Av. Daily Attendance OTHER=';
        Av__Daily_Attendance_MAIN_CaptionLbl: label 'Av. Daily Attendance MAIN=';
        Av__Daily_Attendance__OTHER___MAIN__CaptionLbl: label 'Av. Daily Attendance (OTHER + MAIN)=';
}

