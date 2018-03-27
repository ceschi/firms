##### Plotting for CompNet #####

#### Aggregated database ####
# likely misleading graph
plot_avg_size <- ggplot(data=d_size_all %>% group_by(year) %>%
                          summarise(avg_size=sum(szclass*l_count)/sum(l_count)),
                        aes(x=year, y=avg_size))+geom_line(size=1, colour='red') + theme_bw()+stat_smooth(method = 'loess')
plot_avg_size


# relative share of firms' size, by country and by year
plot_relshare_size <- ggplot(data=d_size_all, aes(x=year, y=size_rel_share, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1,byrow=TRUE))+xlab('Year')+ylab('Rel. share')+ggtitle('EU firms are small')
plot_relshare_size


# relative share of employment by firms' size, by country and by year
plot_relshare_emp <- ggplot(data=d_size_all, aes(x=year, y=rel_emp_share, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1,byrow=TRUE))+xlab('Year')+ylab('Rel. employment share')+ggtitle('EU workers cluster in big firms')
plot_relshare_emp


# labour cost per employee (lc_l) dynamics by size class and country -- NORMALISED
plot_lc_l_norm <- ggplot(data=d_size_all, aes(x=year, y=lc_l_mean_norm, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1,byrow=TRUE))+xlab('Year')+ylab('Mean labour cost per employee, ')+ggtitle('Labour cost evolution')
plot_lc_l_norm

# labour cost per employee (lc_l) dynamics by size class and country
plot_lc_l <- ggplot(data=d_size_all, aes(x=year, y=lc_l_mean, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1,byrow=TRUE))+xlab('Year')+ylab('Mean labour cost per employee, levels')+ggtitle('Big firms, big money')
plot_lc_l

# Country specific graphs on normalized labour cost per employee, on average within size class
for (i in 1:length(unique(d_size_all$country))){
  p <- ggplot(data=subset(d_size_all, country==unique(d_size_all$country)[i]), aes(x=year, y=lc_l_mean_norm, colour=as.factor(szclass)))+
    geom_line(size=1)+theme_bw()+labs(colour='Size class')+xlab('Year')+ylab('Mean labour cost per employee')+
    ggtitle(unique(d_size_all$country)[i])
  print(p)
  ggsave(filename=paste0(unique(d_size_all$country)[i], '.pdf'),
         plot=p,
         path = graphs_dir,
         device='pdf',
         height=8, width=14.16, units='in')
}
rm(p, i)

# Unit labour cost
plot_ulc <- ggplot(d_size_all, aes(x=year, y=ulc_mean, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1, byrow = T))+ylab('Unit labour cost')+xlab('Year')+
  ggtitle('ULC')
plot_ulc

# Financial constrained firms, from balance sheets
plot_safe <- ggplot(d_size_all, aes(x=year, y=SAFE, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1, byrow = T))+ylab('Share of finconstr firms')+xlab('Year')+
  ggtitle('Share of finconstr firms according to balance sheet')
plot_safe

# Self reported financial constrains
plot_absconstr <- ggplot(d_size_all, aes(x=year, y=absconstrained, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1, byrow = T))+ylab('Share of perceived finconstr firms')+xlab('Year')+
  ggtitle('Share of self-reporting finconstr firms: big firms perceive more constrains')
plot_absconstr

# Financial gap
plot_fingap <- ggplot(d_size_all, aes(x=year,y=financial_gap_mean, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~country, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position=c(.68,.07))+
  guides(colour=guide_legend(nrow=1, byrow = T))+ylab('Financial gap')+xlab('Year')+
  ggtitle('')
plot_fingap

#### Macro sector visualization ####

# Sector relative employment by size
plot_mac <- ggplot(d_ind_all, aes(x=year, y=mac_rel_share, colour=as.factor(szclass), group=country))+
  geom_line(size=1)+facet_wrap(country~mac_sector, scales='free_y')+theme_bw()
plot_mac


# Sectoral, country average collateral levels
plot_sec_collateral_mean <- ggplot(data=d_ind_all %>%
                                     group_by(year, mac_sector, szclass) %>% 
                                     summarise(collateral_mean2=collateral_mean %>% na.omit(.) %>% mean()),
                                   aes(x=year, y=collateral_mean2, colour=as.factor(szclass)))+
        geom_line(size=1)+facet_wrap(~mac_sector, scales='free_y')+theme_bw()+ylab('Collateral %')+xlab('Year')+
        ggtitle('Collateral mean by sector')+labs(colour='Size class')
plot_sec_collateral_mean

# Sectoral, country average ULC levels
plot_sec_ULC_mean <- ggplot(data=d_ind_all %>%
                                     group_by(year, mac_sector, szclass) %>% 
                                     summarise(ulc_mean2 = ulc_mean %>% na.omit(.) %>% mean()),
                                   aes(x=year, y=ulc_mean2, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~mac_sector, scales='free_y')+theme_bw()+ylab('ULC')+xlab('Year')+
  ggtitle('ULC mean by sector, all countries')+labs(colour='Size class')
plot_sec_ULC_mean

# sectoral financial gap evolution, crosscountry
plot_sec_fingap <- ggplot(full_ind %>% 
                            group_by(year, mac_sector, szclass) %>% 
                            summarise(financial_gap_crosscountry=wageshare_mean %>% na.omit(.) %>% mean()), 
                          aes(x=year,y=financial_gap_crosscountry, colour=as.factor(szclass)))+
  geom_line(size=1)+facet_wrap(~mac_sector, scales='free_y')+theme_bw()+labs(colour='Size class')+theme(legend.position='bottom')+
  guides(colour=guide_legend(nrow=1, byrow = T))+ylab('Financial gap')+xlab('Year')+
  ggtitle('')
plot_sec_fingap



# ideal plot structure: use ggridges to visualise the
# the evolution of percentiles over time, by sector and
# by size of firm. Optionally also by country.
# This could be performed on a variety of indexes such as
# ULC, LC, L, constraints (SAFE, abconstrain), and others.
