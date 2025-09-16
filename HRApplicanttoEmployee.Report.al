#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51177 "HR Applicant to Employee"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(UnknownTable61225;UnknownTable61225)
        {
            RequestFilterFields = "Application No",Qualified;
            column(ReportForNavId_3952; 3952)
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
            column(HR_Job_Applications__Application_No_;"Application No")
            {
            }
            column(HR_Job_Applications__FullName;"HRM-Job Applications (B)".FullName)
            {
            }
            column(HR_Job_Applications__Postal_Address_;"Postal Address")
            {
            }
            column(HR_Job_Applications_City;City)
            {
            }
            column(HR_Job_Applications__Post_Code_;"Post Code")
            {
            }
            column(HR_Job_ApplicationsCaption;HR_Job_ApplicationsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Job_Applications__Application_No_Caption;FieldCaption("Application No"))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(HR_Job_Applications__Postal_Address_Caption;FieldCaption("Postal Address"))
            {
            }
            column(HR_Job_Applications_CityCaption;FieldCaption(City))
            {
            }
            column(HR_Job_Applications__Post_Code_Caption;FieldCaption("Post Code"))
            {
            }

            trigger OnPostDataItem()
            begin

                if "HRM-Job Applications (B)".Find('-') then begin

                         if Confirm('Are you sure you want to upload qualified applicants information to the Employee card?',true)=false then exit;
                         begin

                            repeat

                                if "Employee No"='' then
                                HRSetup.Get;
                                HRSetup.TestField("Employee Nos.");
                                NoSeriesMgt.InitSeries(HRSetup."Employee Nos.","HRM-Job Applications (B)"."No. Series",0D,"Employee No","No. Series");


                                HREmp.Init;
                                HREmp."No.":="HRM-Job Applications (B)"."Employee No";
                                HREmp."First Name":="First Name";
                                HREmp."Middle Name":="Middle Name";
                                HREmp."Last Name":="Last Name";
                                HREmp."Search Name":="Search Name";
                                HREmp."Postal Address":="Postal Address";
                                HREmp."Residential Address":="Residential Address";
                                HREmp.City:=City;
                                HREmp."Post Code":="Post Code";
                                HREmp.County:=County;
                                HREmp."Home Phone Number":="Home Phone Number";
                                HREmp."Cellular Phone Number":="Cell Phone Number";
                                HREmp."Work Phone Number":="Work Phone Number";
                                HREmp."Ext.":="Ext.";
                                HREmp."E-Mail":="E-Mail";
                                HREmp."ID Number":="ID Number";
                                HREmp.Gender:=Gender;
                                HREmp.Citizenship:="Country Code";
                                HREmp."Fax Number":="Fax Number";
                                HREmp."Marital Status":="Marital Status";
                                HREmp."Ethnic Origin":="Ethnic Origin";
                                HREmp."First Language (R/W/S)":="First Language (R/W/S)";
                                //HREmp."Has Driving Licence":=HREmp."Has Driving Licence"::"Driving Licence";
                                HREmp.Disabled:=Disabled;
                                //HREmp."Health Assesment?:="Health Assesment?";
                                HREmp."Health Assesment Date":="Health Assesment Date";
                                HREmp."Date Of Birth":="Date Of Birth";
                                HREmp.Age:=Age;
                                HREmp."Second Language (R/W/S)":="Second Language (R/W/S)";
                                HREmp."Additional Language":="Additional Language";
                                HREmp."Postal Address2":="Postal Address2";
                                HREmp."Postal Address3":="Postal Address3";
                                HREmp."Residential Address2":="Residential Address2";
                                HREmp."Residential Address3":="Residential Address3";
                                HREmp."Post Code2":="Post Code2";
                                HREmp.Citizenship:=Citizenship;
                                HREmp."Passport Number":="Passport Number";
                                HREmp."First Language Read":="First Language Read";
                                HREmp."First Language Write":="First Language Write";
                                HREmp."First Language Speak":="First Language Speak";
                                HREmp."Second Language Read":="Second Language Read";
                                HREmp."Second Language Write":="Second Language Write";
                                HREmp."Second Language Speak":="Second Language Speak";
                                HREmp."PIN Number":="PIN Number";
                                HREmp."Job Application No":="Application No";
                                "HRM-Job Applications (B)".Modify;
                                HREmp.Insert;
                              until "HRM-Job Applications (B)".Next=0;
                              Message('Applicants Information succesfully uploaded.');
                          end;

                end else begin
                Message('No qualified applicants were found');
                end;
            end;

            trigger OnPreDataItem()
            begin
                if JopAppNo='' then begin
                //UPLOAD ALL QUALIFIED APPLICANTS WHO HAVE NOT ALREADY BEEN EMPLOYED
                "HRM-Job Applications (B)".Reset;
                "HRM-Job Applications (B)".SetRange("HRM-Job Applications (B)".Qualified,true);
                //"HR Job Applications".SETRANGE("HR Job Applications"."Employee No",'<>%1','');

                end else begin
                //UPLOAD THE SELECTED APPLICANT
                "HRM-Job Applications (B)".Reset;
                "HRM-Job Applications (B)".SetRange("HRM-Job Applications (B)"."Application No",JopAppNo);
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

    trigger OnPreReport()
    begin
                      JopAppNo:="HRM-Job Applications (B)".GetFilter("HRM-Job Applications (B)"."Application No");
    end;

    var
        HREmp: Record UnknownRecord61188;
        HRSetup: Record UnknownRecord61675;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JopAppNo: Code[10];
        HR_Job_ApplicationsCaptionLbl: label 'HR Job Applications';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
}

