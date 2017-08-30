 
--GM诹访子
function c30011.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c30011.syncon)
	e1:SetOperation(c30011.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30011,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c30011.cost)
	e2:SetTarget(c30011.tdtg1)
	e2:SetOperation(c30011.tdop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30011,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c30011.cost)
	e3:SetTarget(c30011.tdtg2)
	e3:SetOperation(c30011.tdop2)
	c:RegisterEffect(e3)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--summon success
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c30011.sumsuc)
	c:RegisterEffect(e5)
	--cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.FALSE)
	c:RegisterEffect(e6)
	--cannot synchro
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot xyz
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
end
function c30011.matfilter1(c,syncard)
	return c:IsSetCard(0x6208) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c30011.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c30011.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(30000)==0 then	
	return g1:IsExists(c30011.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c30011.synfilter3,1,nil,lv-tlv)
	end	
end
function c30011.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c30011.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c30011.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c30011.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c30011.synfilter1,1,nil,lv,g1,g2)
end
function c30011.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c30011.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c30011.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c30011.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(30000)==0 then	
		local t1=g1:FilterSelect(tp,c30011.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c30011.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO+REASON_RULE)
end
function c30011.cfilter1(c)
	return c:IsAbleToDeckAsCost()
end
function c30011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30011.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c30011.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c30011.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(30011)==0
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	e:GetHandler():RegisterFlagEffect(30011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,g:GetCount()*800)
end
function c30011.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	Duel.Recover(tp,ct*800,REASON_EFFECT)
end
function c30011.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c30011.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(30011)==0
		and Duel.IsExistingMatchingCard(c30011.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c30011.filter2,tp,0,LOCATION_ONFIELD,nil)
	e:GetHandler():RegisterFlagEffect(30011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,g:GetCount()*800)
end
function c30011.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c30011.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	Duel.Recover(tp,ct*800,REASON_EFFECT)
end
function c30011.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
