 
--绯想✿爱丽丝·玛格特罗伊德
function c200005.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200005,3))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c200005.ntcon)
	c:RegisterEffect(e1)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200005,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c200005.cost)
	e1:SetCondition(c200005.con1)
	e1:SetOperation(c200005.op1)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(200005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c200005.spcost)
	e3:SetTarget(c200005.sptg)
	e3:SetOperation(c200005.spop)
	c:RegisterEffect(e3)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(200005,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c200005.cost2)
	e3:SetTarget(c200005.tg2)
	e3:SetOperation(c200005.op2)
	c:RegisterEffect(e3)
end
function c200005.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c200005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(200005)<=0 end
	e:GetHandler():RegisterFlagEffect(200005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c200005.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,3,nil)
end
function c200005.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200105)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
--	and e:GetHandler():GetFlagEffect(200005)<=0 
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
--	e:GetHandler():RegisterFlagEffect(200005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c200005.filter(c,e,tp)
	return c:IsSetCard(0x186) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(3)
end
function c200005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c200005.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c200005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c200005.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c200005.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x700,3,REASON_COST) and e:GetHandler():GetFlagEffect(200005)<=0 end
	Duel.RemoveCounter(tp,1,0,0x700,3,REASON_COST)
	e:GetHandler():RegisterFlagEffect(200005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c200005.filter2(c)
	return c:IsSetCard(0x186) and c:IsAbleToHand()
end
function c200005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200005.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200005.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c200005.filter2,tp,LOCATION_DECK,0,1,nil) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c200005.filter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
	end
end