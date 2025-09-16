#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99901 "Update JAB Admissions"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Headers;UnknownTable61358)
        {
            RequestFilterFields = "First Choice Semester","Admission No";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(KUCCPSIMports);
                KUCCPSIMports.Reset;
                KUCCPSIMports.SetRange(Admin,Headers."Admission No");
                if KUCCPSIMports.Find('-') then begin
                  Headers.Email:=KUCCPSIMports.Email;
                Headers."Emergency Email":=KUCCPSIMports."Slt Mail";
                Headers."ID Number":=KUCCPSIMports."ID Number/BirthCert";
                Headers."Date Of Birth":=KUCCPSIMports."Date of Birth";
                Headers.County:=KUCCPSIMports.County;
                Headers.Phone:=KUCCPSIMports.Phone;
                Headers."Alt. Phone":= KUCCPSIMports."Alt. Phone";
                Headers.Box:= KUCCPSIMports.Box;
                Headers.Town:= KUCCPSIMports.Town;
                Headers."NHIF No":= KUCCPSIMports."NHIF No";
                Headers.Location:= KUCCPSIMports.Location;
                Headers."Name of Chief":= KUCCPSIMports."Name of Chief";
                Headers."Sub-County":= KUCCPSIMports."Sub-County";
                Headers.Constituency:= KUCCPSIMports.Constituency;
                Headers."OLevel School":= KUCCPSIMports."OLevel School";
                Headers."OLevel Year Completed":= KUCCPSIMports."OLevel Year Completed";
                Headers."Telephone No. 1":=KUCCPSIMports.Phone;
                Headers."Telephone No. 2":=KUCCPSIMports. "Emergency Phone No1";
                Headers."Address for Correspondence2":= KUCCPSIMports.Codes;
                Headers."Address for Correspondence3":= KUCCPSIMports.Town;
                  Headers.Modify(true);
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(semester;semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                    TableRelation = "ACA-Semesters".Code;
                }
            }
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
        acadYears.Reset;
        acadYears.SetRange(acadYears.Current,true);
        sems.Reset;
        sems.SetRange(sems."Current Semester",true);
        Intakes.Reset;
        Intakes.SetRange(Intakes.Current,true);
        if acadYears.Find('-') then Year:=acadYears.Code;
        if sems.Find('-') then semester:=sems.Code;
        if Intakes.Find('-') then Intake:=Intakes.Code;

        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          end;
    end;

    trigger OnPostReport()
    begin
        //MESSAGE('Processed Successfully');
    end;

    trigger OnPreReport()
    begin
        // IF Year='' THEN
        //  BEGIN
        //    ERROR('Academic Year Missing');
        //  END;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        AdminSetup: Record UnknownRecord61371;
        AdminCode: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Year: Code[20];
        LineNo: Integer;
        SettlementType: Record UnknownRecord61522;
        Intake: Code[20];
        semester: Code[20];
        Processed_JAB_AdmissionsCaptionLbl: label 'Processed JAB Admissions';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        acadYears: Record UnknownRecord61382;
        Intakes: Record UnknownRecord61383;
        sems: Record UnknownRecord61692;
        CompanyInformation: Record "Company Information";
        SirNamez: Code[100];
        OtherNamez: Code[100];
        KUCCPSIMports: Record UnknownRecord70082;
}

