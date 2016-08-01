//
//  CustomLabel.m
//  rointe
//
//  Created by Juanjo Guevara on 22/5/15.
//  Copyright (c) 2015 Juanjo Guevara. All rights reserved.
//

#import "JJMaterialTextfield.h"

@interface JJMaterialTextfield ()
{
    UIView *line;
    UILabel *placeHolderLabel;
    BOOL showError;
}
@end

@implementation JJMaterialTextfield

@synthesize errorColor = _errorColor;
@synthesize lineColor= _lineColor;
@synthesize standByLineColor = _standByLineColor;


#define DEFAULT_ALPHA_LINE 0.8

#pragma mark - Setters And Getters


-(void)setErrorColor:(UIColor *)errorColor
{
    _errorColor = errorColor;
    if (showError)
    {
        [line setBackgroundColor:_errorColor];
    }
}


-(UIColor *)errorColor
{
    if (!_errorColor)
    {
        _errorColor = [UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    }
    
    return _errorColor;
}


-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [line setBackgroundColor:_errorColor];
}

-(UIColor *)lineColor
{
    if (!_lineColor)
    {
        _lineColor = [UIColor lightGrayColor];
    }
    return _lineColor;
}


-(void)setStandByLineColor:(UIColor *)standByLineColor
{
    _standByLineColor = standByLineColor;
    [line setBackgroundColor:standByLineColor];
}



#pragma mark - Initialisers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
    
}

- (void)commonInit
{
    line = [[UIView alloc] init];
    line.backgroundColor = self.standByLineColor;
    [self addSubview:line];
    
    self.clipsToBounds = NO;
    [self setEnableMaterialPlaceHolder:self.enableMaterialPlaceHolder];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textFieldDidChange:self];
}

- (IBAction)textFieldDidChange:(id)sender
{
    if (self.enableMaterialPlaceHolder) {
        
        placeHolderLabel.alpha = 1;
        self.attributedPlaceholder = nil;
        
        if (!CGAffineTransformIsIdentity(placeHolderLabel.transform))
        {
            return;
        }
        
        CGAffineTransform originalTransform = CGAffineTransformMakeScale(0.6f, 0.6f);

        originalTransform = CGAffineTransformTranslate(originalTransform, -placeHolderLabel.frame.size.width*0.30, -placeHolderLabel.frame.size.height * 1.5 );
        [self setPlaceholderTransform:originalTransform animated:YES];
        
    }
}

-(void)setPlaceholderTransform:(CGAffineTransform)transform animated:(BOOL)yesOrNo
{
    if (!yesOrNo)
    {
        [placeHolderLabel setTransform:transform];
        return;
    }
    
    
    CGFloat duration = 0.5;
    CGFloat delay = 0;
    CGFloat damping = 0.6;
    CGFloat velocity = 1;
    
    [UIView animateWithDuration:duration
                          delay:delay
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            [placeHolderLabel setTransform:transform];
                            
                        }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (IBAction)textFieldDidEndEditing:(id)sender
{
    if (self.enableMaterialPlaceHolder)
    {
        
        if (!self.text || self.text.length > 0) {
            placeHolderLabel.alpha = 1;
            self.attributedPlaceholder = nil;
        }
        
        if (!(!self.text || self.text.length <= 0) && !CGAffineTransformIsIdentity(placeHolderLabel.transform))
        {
            return;
        }
        
        [self setPlaceholderTransform:CGAffineTransformIdentity animated:YES];
        
    }
}


-(IBAction)clearAction:(id)sender
{
    self.text = @"";
    [self textFieldDidChange:self];
}

-(void)highlight
{
    
    [UIView animateWithDuration: 0.3 // duración
                          delay: 0 // sin retardo antes de comenzar
                        options: UIViewAnimationOptionCurveEaseInOut //opciones
                     animations:^{
                         
                         if (showError) {
                             line.backgroundColor=self.errorColor;
                         }
                         else {
                             line.backgroundColor=self.lineColor;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             //finalizacion
                         }
                     }];
    
}

-(void)unhighlight
{
    [UIView animateWithDuration: 0.3 // duración
                          delay: 0 // sin retardo antes de comenzar
                        options: UIViewAnimationOptionCurveEaseInOut //opciones
                     animations:^{
                         
                         if (showError) {
                             line.backgroundColor = self.errorColor;
                         }
                         else {
                             line.backgroundColor = self.standByLineColor?:[self.lineColor colorWithAlphaComponent:DEFAULT_ALPHA_LINE];
                         }
                         
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             //finalizacion
                         }
                     }];
    
}

- (void)setPlaceholderAttributes:(NSDictionary *)placeholderAttributes
{
    _placeholderAttributes = placeholderAttributes;
    [self setPlaceholder:self.placeholder];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    
    NSDictionary *atts = @{NSForegroundColorAttributeName: [self.textColor colorWithAlphaComponent:DEFAULT_ALPHA_LINE],
                           NSFontAttributeName : [self.font fontWithSize: self.font.pointSize]};
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder ?: @"" attributes: self.placeholderAttributes ?: atts];
    
    [self setEnableMaterialPlaceHolder:self.enableMaterialPlaceHolder];
}

- (void)setEnableMaterialPlaceHolder:(BOOL)enableMaterialPlaceHolder
{
    _enableMaterialPlaceHolder = enableMaterialPlaceHolder;
    
    if (!placeHolderLabel) {
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 0, self.frame.size.height)];
        [self addSubview:placeHolderLabel];
    }
    placeHolderLabel.alpha = 0;
    placeHolderLabel.attributedText = self.attributedPlaceholder;
    [placeHolderLabel sizeToFit];
    
}

- (BOOL)becomeFirstResponder
{
    BOOL returnValue = [super becomeFirstResponder];
    
    [self highlight];
    
    return returnValue;
}

- (BOOL)resignFirstResponder
{
    BOOL returnValue = [super resignFirstResponder];
    
    [self unhighlight];
    
    return returnValue;
}

- (void)showError
{
    showError = YES;
    line.backgroundColor = self.errorColor;
}

- (void)hideError
{
    showError = NO;
    line.backgroundColor = self.lineColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    line.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
}

@end
