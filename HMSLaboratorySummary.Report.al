#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77737 "HMS Laboratory Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Laboratory Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61416;UnknownTable61416)
        {
            DataItemTableView = sorting("Laboratory No.");
            RequestFilterFields = "Laboratory No.","Laboratory Date";
            column(ReportForNavId_7278; 7278)
            {
            }
            column(Date_Printed______FORMAT_TODAY_0_4_;'Date Printed: ' + Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(No;"HMS-Laboratory Form Header"."Laboratory No.")
            {
            }
            column(Date;"HMS-Laboratory Form Header"."Laboratory Date")
            {
            }
            column(Name;"HMS-Laboratory Form Header".Surname)
            {
            }
            column(PatNo;"HMS-Laboratory Form Header"."Patient Ref. No.")
            {
            }
            column(Seq;Seq)
            {
            }
            dataitem(UnknownTable61417;UnknownTable61417)
            {
                DataItemLink = "Laboratory No."=field("Laboratory No.");
                column(ReportForNavId_7451; 7451)
                {
                }
                column(Testcode;"HMS-Laboratory Test Line"."Laboratory Test Code")
                {
                }
                column(TName;"HMS-Laboratory Test Line"."Laboratory Test Name")
                {
                }
                column(Specimen;"Specimen Name")
                {
                }
                column(Positive;"HMS-Laboratory Test Line".Positive)
                {
                }
                column(Rmark;"HMS-Laboratory Test Line".Remarks)
                {
                }
                column(Scode;"HMS-Laboratory Test Line"."Specimen Code")
                {
                }
                column(TestCount;"HMS-Laboratory Test Line"."Test Count")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Seq:=Seq+1;
                Patient.Reset;
                PatientName:='';
                PFNo:='';
                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' ' +Patient."Middle Name" +' ' +Patient."Last Name";
                    if Patient."Patient Type"=Patient."patient type"::Others then
                      begin
                        PFNo:=Patient."Student No.";
                      end
                    else if Patient."Patient Type"=Patient."patient type"::" " then
                      begin
                        PFNo:=Patient."Patient No.";
                      end
                    else
                      begin
                        PFNo:=Patient."Employee No.";
                      end;
                  end
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Laboratory No.");
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
        Patient: Record UnknownRecord61402;
        PatientName: Text[200];
        PFNo: Code[20];
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        LABORATORY_TESTS_LISTINGCaptionLbl: label 'LABORATORY TESTS LISTING';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        PF_No_CaptionLbl: label 'PF/No.';
        ResponsibleCaptionLbl: label 'Responsible';
        Patient_nameCaptionLbl: label 'Patient name';
        Test_PackageCaptionLbl: label 'Test Package';
        TestCaptionLbl: label 'Test';
        SpecimenCaptionLbl: label 'Specimen';
        StatusCaptionLbl: label 'Status';
        Seq: Integer;
}

