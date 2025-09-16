#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9255 "To-dos Matrix"
{
    Caption = 'To-dos Matrix';
    DataCaptionExpression = FORMAT(SELECTSTR(OutputOption + 1,Text001));
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "RM Matrix Management";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'This field is used internally.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Campaign: Record Campaign;
                        SalesPurchPerson: Record "Salesperson/Purchaser";
                        Contact: Record Contact;
                        Team: Record Team;
                    begin
                        case TableOption of
                          Tableoption::Salesperson:
                            begin
                              SalesPurchPerson.Get("No.");
                              Page.RunModal(0,SalesPurchPerson);
                            end;
                          Tableoption::Team:
                            begin
                              Team.Get("No.");
                              Page.RunModal(0,Team);
                            end;
                          Tableoption::Campaign:
                            begin
                              Campaign.Get("No.");
                              Page.RunModal(0,Campaign);
                            end;
                          Tableoption::Contact:
                            begin
                              Contact.Get("No.");
                              Page.RunModal(0,Contact);
                            end;
                        end;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'This field is used internally.';
                }
                field(Field1;MATRIX_CellData[1])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(1);
                    end;
                }
                field(Field2;MATRIX_CellData[2])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(2);
                    end;
                }
                field(Field3;MATRIX_CellData[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(3);
                    end;
                }
                field(Field4;MATRIX_CellData[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(4);
                    end;
                }
                field(Field5;MATRIX_CellData[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(5);
                    end;
                }
                field(Field6;MATRIX_CellData[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(6);
                    end;
                }
                field(Field7;MATRIX_CellData[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(7);
                    end;
                }
                field(Field8;MATRIX_CellData[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(8);
                    end;
                }
                field(Field9;MATRIX_CellData[9])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(9);
                    end;
                }
                field(Field10;MATRIX_CellData[10])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(10);
                    end;
                }
                field(Field11;MATRIX_CellData[11])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(11);
                    end;
                }
                field(Field12;MATRIX_CellData[12])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(12);
                    end;
                }
                field(Field13;MATRIX_CellData[13])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(13);
                    end;
                }
                field(Field14;MATRIX_CellData[14])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(14);
                    end;
                }
                field(Field15;MATRIX_CellData[15])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(15);
                    end;
                }
                field(Field16;MATRIX_CellData[16])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(16);
                    end;
                }
                field(Field17;MATRIX_CellData[17])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(17);
                    end;
                }
                field(Field18;MATRIX_CellData[18])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(18);
                    end;
                }
                field(Field19;MATRIX_CellData[19])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(19);
                    end;
                }
                field(Field20;MATRIX_CellData[20])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(20);
                    end;
                }
                field(Field21;MATRIX_CellData[21])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[21];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(21);
                    end;
                }
                field(Field22;MATRIX_CellData[22])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[22];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(22);
                    end;
                }
                field(Field23;MATRIX_CellData[23])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[23];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(23);
                    end;
                }
                field(Field24;MATRIX_CellData[24])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[24];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(24);
                    end;
                }
                field(Field25;MATRIX_CellData[25])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[25];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(25);
                    end;
                }
                field(Field26;MATRIX_CellData[26])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[26];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(26);
                    end;
                }
                field(Field27;MATRIX_CellData[27])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[27];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(27);
                    end;
                }
                field(Field28;MATRIX_CellData[28])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[28];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(28);
                    end;
                }
                field(Field29;MATRIX_CellData[29])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[29];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(29);
                    end;
                }
                field(Field30;MATRIX_CellData[30])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[30];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(30);
                    end;
                }
                field(Field31;MATRIX_CellData[31])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[31];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(31);
                    end;
                }
                field(Field32;MATRIX_CellData[32])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,' + ColumnCaptions[32];
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    trigger OnDrillDown()
                    begin
                        SetFilters;
                        MatrixOnDrillDown(32);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        if (Type = Type::Person) and (TableOption = Tableoption::Contact) then
          NameIndent := 1
        else
          NameIndent := 0;

        MATRIX_CurrentColumnOrdinal := 0;
        while MATRIX_CurrentColumnOrdinal < MATRIX_NoOfMatrixColumns do begin
          MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
          MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        end;

        FormatLine;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindRec(TableOption,Rec,Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(NextRec(TableOption,Rec,Steps));
    end;

    trigger OnOpenPage()
    begin
        MATRIX_NoOfMatrixColumns := ArrayLen(MATRIX_CellData);
        if IncludeClosed then
          SetRange("To-do Closed Filter")
        else
          SetRange("To-do Closed Filter",false);

        if StatusFilter <> Statusfilter::" " then
          SetRange("To-do Status Filter",StatusFilter - 1)
        else
          SetRange("To-do Status Filter");

        if PriorityFilter <> Priorityfilter::" " then
          SetRange("Priority Filter",PriorityFilter - 1)
        else
          SetRange("Priority Filter");

        ValidateFilter;
        ValidateTableOption;
    end;

    var
        ToDos: Record "To-do";
        MatrixRecords: array [32] of Record Date;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Cont: Record Contact;
        Team: Record Team;
        Campaign: Record Campaign;
        OutputOption: Option "No. of To-dos","Contact No.";
        TableOption: Option Salesperson,Team,Campaign,Contact;
        StatusFilter: Option " ","Not Started","In Progress",Completed,Waiting,Postponed;
        PriorityFilter: Option " ",Low,Normal,High;
        IncludeClosed: Boolean;
        [InDataSet]
        StyleIsStrong: Boolean;
        FilterSalesPerson: Code[250];
        FilterTeam: Code[250];
        FilterCampaign: Code[250];
        FilterContact: Code[250];
        Text001: label 'No. of To-dos,Contact No.';
        MATRIX_NoOfMatrixColumns: Integer;
        MATRIX_CellData: array [32] of Text[1024];
        ColumnCaptions: array [32] of Text[1024];
        ColumnDateFilters: array [32] of Text[50];
        [InDataSet]
        NameIndent: Integer;
        MultipleTxt: label 'Multiple';

    local procedure SetFilters()
    begin
        if StatusFilter <> Statusfilter::" " then begin
          SetRange("To-do Status Filter",StatusFilter - 1);
          ToDos.SetRange(Status,StatusFilter - 1);
        end else begin
          SetRange("To-do Status Filter");
          ToDos.SetRange(Status);
        end;

        ToDos.SetFilter("System To-do Type",'%1|%2',"system to-do type filter"::Organizer,
          "system to-do type filter"::"Salesperson Attendee");

        if IncludeClosed then
          ToDos.SetRange(Closed)
        else
          ToDos.SetRange(Closed,false);

        if PriorityFilter <> Priorityfilter::" " then begin
          SetRange("Priority Filter",PriorityFilter - 1);
          ToDos.SetRange(Priority,PriorityFilter - 1);
        end else begin
          SetRange("Priority Filter");
          ToDos.SetRange(Priority);
        end;

        case TableOption of
          Tableoption::Salesperson:
            begin
              SetRange("Salesperson Filter","No.");
              SetFilter(
                "System To-do Type Filter",'%1|%2',
                "system to-do type filter"::Organizer,
                "system to-do type filter"::"Salesperson Attendee");
            end;
          Tableoption::Team:
            begin
              SetRange("Team Filter","No.");
              SetRange("System To-do Type Filter","system to-do type filter"::Team);
            end;
          Tableoption::Campaign:
            begin
              SetRange("Campaign Filter","No.");
              SetRange("System To-do Type Filter","system to-do type filter"::Organizer);
            end;
          Tableoption::Contact:
            if Type = Type::Company then begin
              SetRange("Contact Filter");
              SetRange("Contact Company Filter","Company No.");
              SetRange(
                "System To-do Type Filter","system to-do type filter"::"Contact Attendee");
            end else begin
              SetRange("Contact Filter","No.");
              SetRange("Contact Company Filter");
              SetRange(
                "System To-do Type Filter","system to-do type filter"::"Contact Attendee");
            end;
        end;
    end;

    local procedure FindRec(TableOpt: Option Salesperson,Teams,Campaign,Contact;var RMMatrixMgt: Record "RM Matrix Management";Which: Text[250]): Boolean
    var
        Found: Boolean;
    begin
        case TableOpt of
          Tableopt::Salesperson:
            begin
              RMMatrixMgt."No." := CopyStr(RMMatrixMgt."No.",1,MaxStrLen(SalespersonPurchaser.Code));
              SalespersonPurchaser.Code := CopyStr(RMMatrixMgt."No.",1,MaxStrLen(SalespersonPurchaser.Code));
              Found := SalespersonPurchaser.Find(Which);
              if Found then
                CopySalesPersonToBuf(SalespersonPurchaser,RMMatrixMgt);
            end;
          Tableopt::Teams:
            begin
              RMMatrixMgt."No." := CopyStr(RMMatrixMgt."No.",1,MaxStrLen(Team.Code));
              Team.Code := RMMatrixMgt."No.";
              Found := Team.Find(Which);
              if Found then
                CopyTeamToBuf(Team,RMMatrixMgt);
            end;
          Tableopt::Campaign:
            begin
              Campaign."No." := RMMatrixMgt."No.";
              Found := Campaign.Find(Which);
              if Found then
                CopyCampaignToBuf(Campaign,RMMatrixMgt);
            end;
          Tableopt::Contact:
            begin
              Cont."Company Name" := RMMatrixMgt."Company Name";
              Cont.Type := RMMatrixMgt.Type;
              Cont.Name := CopyStr(RMMatrixMgt.Name,1,MaxStrLen(Cont.Name));
              Cont."No." := RMMatrixMgt."No.";
              Cont."Company No." := RMMatrixMgt."Company No.";
              Found := Cont.Find(Which);
              if Found then
                CopyContactToBuf(Cont,RMMatrixMgt);
            end;
        end;
        exit(Found);
    end;

    local procedure NextRec(TableOpt: Option Salesperson,Teams,Campaign,Contact;var RMMatrixMgt: Record "RM Matrix Management";Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        case TableOpt of
          Tableopt::Salesperson:
            begin
              RMMatrixMgt."No." := CopyStr(RMMatrixMgt."No.",1,MaxStrLen(SalespersonPurchaser.Code));
              SalespersonPurchaser.Code := CopyStr(RMMatrixMgt."No.",1,MaxStrLen(SalespersonPurchaser.Code));
              ResultSteps := SalespersonPurchaser.Next(Steps);
              if ResultSteps <> 0 then
                CopySalesPersonToBuf(SalespersonPurchaser,RMMatrixMgt);
            end;
          Tableopt::Teams:
            begin
              RMMatrixMgt."No." := CopyStr(RMMatrixMgt."No.",1,MaxStrLen(Team.Code));
              Team.Code := RMMatrixMgt."No.";
              ResultSteps := Team.Next(Steps);
              if ResultSteps <> 0 then
                CopyTeamToBuf(Team,RMMatrixMgt);
            end;
          Tableopt::Campaign:
            begin
              Campaign."No." := RMMatrixMgt."No.";
              ResultSteps := Campaign.Next(Steps);
              if ResultSteps <> 0 then
                CopyCampaignToBuf(Campaign,RMMatrixMgt);
            end;
          Tableopt::Contact:
            begin
              Cont."Company Name" := RMMatrixMgt."Company Name";
              Cont.Type := RMMatrixMgt.Type;
              Cont.Name := CopyStr(RMMatrixMgt.Name,1,MaxStrLen(Cont.Name));
              Cont."No." := RMMatrixMgt."No.";
              Cont."Company No." := RMMatrixMgt."Company No.";
              ResultSteps := Cont.Next(Steps);
              if ResultSteps <> 0 then
                CopyContactToBuf(Cont,RMMatrixMgt);
            end;
        end;
        exit(ResultSteps);
    end;

    local procedure CopySalesPersonToBuf(var SalesPurchPerson: Record "Salesperson/Purchaser";var RMMatrixMgt: Record "RM Matrix Management")
    begin
        with RMMatrixMgt do begin
          Init;
          "Company Name" := SalesPurchPerson.Code;
          Type := Type::Person;
          Name := SalesPurchPerson.Name;
          "No." := SalesPurchPerson.Code;
          "Company No." := '';
        end;
    end;

    local procedure CopyCampaignToBuf(var TheCampaign: Record Campaign;var RMMatrixMgt: Record "RM Matrix Management")
    begin
        with RMMatrixMgt do begin
          Init;
          "Company Name" := TheCampaign."No.";
          Type := Type::Person;
          Name := TheCampaign.Description;
          "No." := TheCampaign."No.";
          "Company No." := '';
        end;
    end;

    local procedure CopyContactToBuf(var TheCont: Record Contact;var RMMatrixMgt: Record "RM Matrix Management")
    begin
        with RMMatrixMgt do begin
          Init;
          "Company Name" := TheCont."Company Name";
          Type := TheCont.Type;
          Name := TheCont.Name;
          "No." := TheCont."No.";
          "Company No." := TheCont."Company No.";
        end;
    end;

    local procedure CopyTeamToBuf(var TheTeam: Record Team;var RMMatrixMgt: Record "RM Matrix Management")
    begin
        with RMMatrixMgt do begin
          Init;
          "Company Name" := TheTeam.Code;
          Type := Type::Person;
          Name := TheTeam.Name;
          "No." := TheTeam.Code;
          "Company No." := '';
        end;
    end;

    local procedure ValidateTableOption()
    begin
        SetRange("Contact Company Filter");
        case TableOption of
          Tableoption::Salesperson:
            begin
              SetFilter("Team Filter",FilterTeam);
              SetFilter("Campaign Filter",FilterCampaign);
              SetFilter("Contact Filter",FilterContact);
              ValidateFilter;
            end;
          Tableoption::Team:
            begin
              SetFilter("Salesperson Filter",FilterSalesPerson);
              SetFilter("Campaign Filter",FilterCampaign);
              SetFilter("Contact Filter",FilterContact);
              ValidateFilter;
            end;
          Tableoption::Campaign:
            begin
              SetFilter("Salesperson Filter",FilterSalesPerson);
              SetFilter("Team Filter",FilterTeam);
              SetFilter("Contact Filter",FilterContact);
              ValidateFilter;
            end;
          Tableoption::Contact:
            begin
              SetFilter("Salesperson Filter",FilterSalesPerson);
              SetFilter("Team Filter",FilterTeam);
              SetFilter("Campaign Filter",FilterCampaign);
              ValidateFilter;
            end;
        end;
    end;

    local procedure ValidateFilter()
    begin
        case TableOption of
          Tableoption::Salesperson:
            UpdateSalesPersonFilter;
          Tableoption::Team:
            UpdateTeamFilter;
          Tableoption::Campaign:
            UpdateCampaignFilter;
          Tableoption::Contact:
            UpdateContactFilter;
        end;
        CurrPage.Update(false);
    end;

    local procedure UpdateSalesPersonFilter()
    begin
        SalespersonPurchaser.Reset;
        SalespersonPurchaser.SetFilter(Code,FilterSalesPerson);
        SalespersonPurchaser.SetFilter("Team Filter",FilterTeam);
        SalespersonPurchaser.SetFilter("Campaign Filter",FilterCampaign);
        SalespersonPurchaser.SetFilter("Contact Company Filter",FilterContact);
        SalespersonPurchaser.SetFilter("To-do Status Filter",GetFilter("To-do Status Filter"));
        SalespersonPurchaser.SetFilter("Closed To-do Filter",GetFilter("To-do Closed Filter"));
        SalespersonPurchaser.SetFilter("Priority Filter",GetFilter("Priority Filter"));
        SalespersonPurchaser.SetRange("To-do Entry Exists",true);
    end;

    local procedure UpdateCampaignFilter()
    begin
        Campaign.Reset;
        Campaign.SetFilter("No.",FilterCampaign);
        Campaign.SetFilter("Salesperson Filter",FilterSalesPerson);
        Campaign.SetFilter("Team Filter",FilterTeam);
        Campaign.SetFilter("Contact Company Filter",FilterContact);
        Campaign.SetFilter("To-do Status Filter",GetFilter("To-do Status Filter"));
        Campaign.SetFilter("To-do Closed Filter",GetFilter("To-do Closed Filter"));
        Campaign.SetFilter("Priority Filter",GetFilter("Priority Filter"));
        Campaign.SetRange("To-do Entry Exists",true);
    end;

    local procedure UpdateContactFilter()
    begin
        Cont.Reset;
        Cont.SetCurrentkey("Company Name","Company No.",Type,Name);
        Cont.SetFilter("Company No.",FilterContact);
        Cont.SetFilter("Campaign Filter",FilterCampaign);
        Cont.SetFilter("Salesperson Filter",FilterSalesPerson);
        Cont.SetFilter("Team Filter",FilterTeam);
        Cont.SetFilter("To-do Status Filter",GetFilter("To-do Status Filter"));
        Cont.SetFilter("To-do Closed Filter",GetFilter("To-do Closed Filter"));
        Cont.SetFilter("Priority Filter",GetFilter("Priority Filter"));
        Cont.SetRange("To-do Entry Exists",true);
    end;

    local procedure UpdateTeamFilter()
    begin
        Team.Reset;
        Team.SetFilter(Code,FilterTeam);
        Team.SetFilter("Campaign Filter",FilterCampaign);
        Team.SetFilter("Salesperson Filter",FilterSalesPerson);
        Team.SetFilter("Contact Company Filter",FilterContact);
        Team.SetFilter("To-do Status Filter",GetFilter("To-do Status Filter"));
        Team.SetFilter("To-do Closed Filter",GetFilter("To-do Closed Filter"));
        Team.SetFilter("Priority Filter",GetFilter("Priority Filter"));
        Team.SetRange("To-do Entry Exists",true);
    end;


    procedure Load(MatrixColumns1: array [32] of Text[1024];var MatrixRecords1: array [32] of Record Date;TableOptionLocal: Option Salesperson,Team,Campaign,Contact;ColumnDateFilter: array [32] of Text[50];OutputOptionLocal: Option "No. of To-dos","Contact No.";FilterSalesPersonLocal: Code[250];FilterTeamLocal: Code[250];FilterCampaignLocal: Code[250];FilterContactLocal: Code[250];StatusFilterLocal: Option " ","Not Started","In Progress",Completed,Waiting,Postponed;IncludeClosedLocal: Boolean;PriorityFilterLocal: Option " ",Low,Normal,High)
    var
        i: Integer;
    begin
        CopyArray(ColumnCaptions,MatrixColumns1,1);
        for i := 1 to 32 do
          MatrixRecords[i].Copy(MatrixRecords1[i]);
        TableOption := TableOptionLocal;
        CopyArray(ColumnDateFilters,ColumnDateFilter,1);
        OutputOption := OutputOptionLocal;
        FilterSalesPerson := FilterSalesPersonLocal;
        FilterTeam := FilterTeamLocal;
        FilterCampaign := FilterCampaignLocal;
        FilterContact := FilterContactLocal;
        StatusFilter := StatusFilterLocal;
        IncludeClosed := IncludeClosedLocal;
        PriorityFilter := PriorityFilterLocal;
        SetFilters;
    end;

    local procedure MatrixOnDrillDown(ColumnID: Integer)
    begin
        ToDos.SetRange(Date,MatrixRecords[ColumnID]."Period Start",MatrixRecords[ColumnID]."Period End");
        case TableOption of
          Tableoption::Salesperson:
            ToDos.SetFilter("Salesperson Code","No.");
          Tableoption::Team:
            ToDos.SetFilter("Team Code","No.");
          Tableoption::Campaign:
            ToDos.SetFilter("Campaign No.","No.");
          Tableoption::Contact:
            ToDos.SetFilter("Contact No.","No.");
        end;
        ToDos.SetFilter("Salesperson Code",GetFilter("Salesperson Filter"));
        ToDos.SetFilter("Team Code",GetFilter("Team Filter"));
        ToDos.SetFilter("Contact Company No.",GetFilter("Contact Company Filter"));
        ToDos.SetFilter(Status,GetFilter("To-do Status Filter"));
        ToDos.SetFilter(Closed,GetFilter("To-do Closed Filter"));
        ToDos.SetFilter(Priority,GetFilter("Priority Filter"));
        ToDos.SetFilter("System To-do Type",GetFilter("System To-do Type Filter"));

        Page.RunModal(Page::"To-do List",ToDos);
    end;

    local procedure MATRIX_OnAfterGetRecord(Matrix_ColumnOrdinal: Integer)
    begin
        SetFilters;
        SetRange("Date Filter",MatrixRecords[Matrix_ColumnOrdinal]."Period Start",MatrixRecords[Matrix_ColumnOrdinal]."Period End");
        CalcFields("No. of To-dos");
        if OutputOption <> Outputoption::"Contact No." then begin
          if "No. of To-dos" = 0 then
            MATRIX_CellData[Matrix_ColumnOrdinal] := ''
          else
            MATRIX_CellData[Matrix_ColumnOrdinal] := Format("No. of To-dos");
        end else begin
          if GetFilter("Team Filter") <> '' then
            ToDos.SetFilter("Team Code",GetFilter("Team Filter"));
          if GetFilter("Salesperson Filter") <> '' then
            ToDos.SetFilter("Salesperson Code",GetFilter("Salesperson Filter"));
          if GetFilter("Campaign Filter") <> '' then
            ToDos.SetFilter("Campaign No.",GetFilter("Campaign Filter"));
          if GetFilter("Contact Filter") <> '' then
            ToDos.SetFilter("Contact No.","Contact Filter");
          if GetFilter("Date Filter") <> '' then
            ToDos.SetFilter(Date,GetFilter("Date Filter"));
          if GetFilter("To-do Status Filter") <> '' then
            ToDos.SetFilter(Status,GetFilter("To-do Status Filter"));
          if GetFilter("Priority Filter") <> '' then
            ToDos.SetFilter(Priority,GetFilter("Priority Filter"));
          if GetFilter("To-do Closed Filter") <> '' then
            ToDos.SetFilter(Closed,GetFilter("To-do Closed Filter"));
          if GetFilter("Contact Company Filter") <> '' then
            ToDos.SetFilter("Contact Company No.",GetFilter("Contact Company Filter"));
          if "No. of To-dos" = 0 then
            MATRIX_CellData[Matrix_ColumnOrdinal] := ''
          else
            if "No. of To-dos" > 1 then
              MATRIX_CellData[Matrix_ColumnOrdinal] := MultipleTxt
            else begin
              ToDos.FindFirst;
              if ToDos."Contact No." <> '' then
                MATRIX_CellData[Matrix_ColumnOrdinal] := ToDos."Contact No."
              else
                MATRIX_CellData[Matrix_ColumnOrdinal] := MultipleTxt
            end;
        end;
    end;

    local procedure FormatLine()
    begin
        StyleIsStrong := Type = Type::Company;
    end;
}

