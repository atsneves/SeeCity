//
//  SCCrimesViewController.m
//  SeeCity
//
//  Created by Anderson Neves on 23/01/14.
//  Copyright (c) 2014 Anderson Trajano. All rights reserved.
//

#import "SCCrimesViewController.h"
#import "Globais.h"
#import "SCCrimesCell.h"
@interface SCCrimesViewController ()
{
    Globais *vg;
}
@end

@implementation SCCrimesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tabela.dataSource = self;
    _tabela.delegate = self;
    _vwBoxTitulo.layer.cornerRadius = 5.0f;
    _tabela.layer.cornerRadius = 5.0f;
    
    vg = [Globais shared];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return vg.crimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCrimesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celula"];
    
    NSMutableDictionary *dicCrime = [vg.crimes objectAtIndex:indexPath.row];
    
    NSMutableDictionary *dicCategoria = [dicCrime objectForKey:@"categoria"];
    
    NSLog(@"dicCategoria %@",dicCategoria.description);
    
    cell.txtDescricao.text = [dicCrime objectForKey:@"descricao"];
    
    cell.lblPor.text = [NSString stringWithFormat:@"por: %@",[dicCrime objectForKey:@"usuario"]];
    
    cell.lblTipo.text =[dicCategoria objectForKey:@"descricao"];
    
    cell.imgCategoria.image = [UIImage imageNamed:[dicCategoria objectForKey:@"imagem"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[dicCrime objectForKey:@"data"]];
    
    cell.lblData.text = dateString;
    
    return cell;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actReport:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
