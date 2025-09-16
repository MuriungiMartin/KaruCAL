#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51365 "Shortlisted Students Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Shortlisted Students Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            DataItemTableView = sorting("Application No.");
            RequestFilterFields = "Application No.";
            column(ReportForNavId_2953; 2953)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Application_Form_Header__Application_No__;"Application No.")
            {
            }
            column(Surname_________Other_Names_;Surname + ' ' +"Other Names")
            {
            }
            column(Application_Form_Header__First_Degree_Choice_;"First Degree Choice")
            {
            }
            column(Application_Form_Header__Mean_Grade_Acquired_;"Mean Grade Acquired")
            {
            }
            column(Application_Form_Header__Points_Acquired_;"Points Acquired")
            {
            }
            column(GradeReqd;GradeReqd)
            {
            }
            column(PointsReqd;PointsReqd)
            {
            }
            column(AdmStatus;AdmStatus)
            {
            }
            column(Application_Form_HeaderCaption;Application_Form_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Application_Form_Header__Application_No__Caption;FieldCaption("Application No."))
            {
            }
            column(Applicant_s_nameCaption;Applicant_s_nameCaptionLbl)
            {
            }
            column(Application_Form_Header__First_Degree_Choice_Caption;FieldCaption("First Degree Choice"))
            {
            }
            column(Application_Form_Header__Mean_Grade_Acquired_Caption;FieldCaption("Mean Grade Acquired"))
            {
            }
            column(Application_Form_Header__Points_Acquired_Caption;FieldCaption("Points Acquired"))
            {
            }
            column(Mean_Grade_RequiredCaption;Mean_Grade_RequiredCaptionLbl)
            {
            }
            column(Points_RequiredCaption;Points_RequiredCaptionLbl)
            {
            }
            column(StatusCaption;StatusCaptionLbl)
            {
            }
            dataitem(UnknownTable61362;UnknownTable61362)
            {
                DataItemLink = "Application No."=field("Application No.");
                column(ReportForNavId_4959; 4959)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SubGradeReqd:='';
                    SubjectStatus:='PASSED';
                    SubPoints:=0;
                    SubGrade.Reset;
                    SubGrade.SetRange(SubGrade.Programme,"ACA-Applic. Form Header"."First Degree Choice");
                    SubGrade.SetRange(SubGrade."Subject Code","ACA-Applic. Form Academic"."Subject Code");
                    if SubGrade.Find('-') then
                      begin
                        SubGradeReqd:=SubGrade."Mean Grade";
                        recGrade.Reset;
                        recGrade.Get(SubGradeReqd);
                        SubPoints:=recGrade.Points;
                        recGrade.Reset;
                        if recGrade.Get("ACA-Applic. Form Academic".Grade) then
                          begin
                             if SubPoints>recGrade.Points then
                              begin
                                SubjectStatus:='FAILED';
                              end
                             else
                              begin
                                SubjectStatus:='PASSED';
                              end;
                          end;

                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GradeReqd:='';
                PointsReqd:=0;
                AdmStatus:='FAILED';
                ProgGrade.Reset;
                ProgGrade.SetRange(ProgGrade.Programme,"ACA-Applic. Form Header"."First Degree Choice");
                if ProgGrade.Find('-') then
                  begin
                    GradeReqd:=ProgGrade."Mean Grade";
                    PointsReqd:=ProgGrade."Min Points";
                    if PointsReqd>"ACA-Applic. Form Header"."Points Acquired" then
                      begin
                        AdmStatus:='FAILED';
                      end
                    else
                      begin
                        AdmStatus:='PASSED';
                      end;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Application No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        GradeReqd: Code[20];
        PointsReqd: Integer;
        AdmStatus: Text[30];
        ProgGrade: Record UnknownRecord61384;
        SubGradeReqd: Code[20];
        SubjectStatus: Text[30];
        SubGrade: Record UnknownRecord61385;
        SubPoints: Integer;
        recGrade: Record UnknownRecord61364;
        Application_Form_HeaderCaptionLbl: label 'Application Form Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Applicant_s_nameCaptionLbl: label 'Applicant''s name';
        Mean_Grade_RequiredCaptionLbl: label 'Mean Grade Required';
        Points_RequiredCaptionLbl: label 'Points Required';
        StatusCaptionLbl: label 'Status';
}

