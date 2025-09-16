#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5305 "Outlook Synch. User Setup"
{
    ApplicationArea = Basic;
    Caption = 'Outlook Synch. User Setup';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Outlook Synch. User Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of a user who uses the Windows Server Authentication to log on to Microsoft Dynamics NAV to access the current database. In Microsoft Dynamics NAV the user ID consists of only a user name.';
                }
                field("Synch. Entity Code";"Synch. Entity Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the synchronization entity. The program copied this code from the Code field of the Outlook Synch. Entity table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies a brief description of the synchronization entity. The program copies this description from the Description field of the Outlook Synch. Entity table. This field is filled in when you enter a code in the Synch. Entity Code field.';
                }
                field("No. of Elements";"No. of Elements")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the collections which were selected for the synchronization. The user defines these collections on the Outlook Synch. Setup Details page.';
                }
                field(Condition;Condition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the criteria for defining a set of specific entries to use in the synchronization process. This filter is applied to the table you specified in the Table No. field. For this filter you can use only the CONST and FILTER options.';

                    trigger OnAssistEdit()
                    begin
                        OSynchEntity.Get("Synch. Entity Code");
                        Condition := CopyStr(OSynchSetupMgt.ShowOSynchFiltersForm("Record GUID",OSynchEntity."Table No.",0),1,MaxStrLen(Condition));
                    end;
                }
                field("Synch. Direction";"Synch. Direction")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the direction of the synchronization for the current entry. The following options are available:';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Setup)
            {
                Caption = '&Setup';
                Image = Setup;
                action("S&ynch. Elements")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&ynch. Elements';
                    Image = Hierarchy;
                    RunObject = Page "Outlook Synch. Setup Details";
                    RunPageLink = "User ID"=field("User ID"),
                                  "Synch. Entity Code"=field("Synch. Entity Code"),
                                  "Outlook Collection"=filter(<>'');

                    trigger OnAction()
                    begin
                        CalcFields("No. of Elements");
                    end;
                }
                action("Register in Change Log &Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Register in Change Log &Setup';
                    Ellipsis = true;
                    Image = ImportLog;

                    trigger OnAction()
                    begin
                        OSynchEntity.Get("Synch. Entity Code");
                        OSynchEntity.SetRecfilter;
                        Report.Run(Report::"Outlook Synch. Change Log Set.",true,false,OSynchEntity);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        OutlookSynchSetupDefaults: Codeunit "Outlook Synch. Setup Defaults";
    begin
        OutlookSynchSetupDefaults.InsertOSynchDefaults;
    end;

    var
        OSynchEntity: Record "Outlook Synch. Entity";
        OSynchSetupMgt: Codeunit "Outlook Synch. Setup Mgt.";
}

