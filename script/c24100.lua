--哈德曼的妖怪少女✿古明地恋
--require "expansions/nef/nef"
function c24100.initial_effect(c)
	--synchro summon
	Nef.AddSynchroProcedureWithDesc(c,aux.FilterBoolFunction(Card.IsSetCard,0x514a),aux.NonTuner(nil),1,aux.Stringid(24100,0))
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24100,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c24100.sprcon)
	e1:SetOperation(c24100.sprop)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24100,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c24100.spcon)
	e2:SetTarget(c24100.sptg)
	e2:SetOperation(c24100.spop)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetDescription(aux.Stringid(24100,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c24100.dcon)
	e3:SetOperation(c24100.dop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--inactivatable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	e6:SetValue(c24100.effectfilter)
	c:RegisterEffect(e6)
end
function c24100.sprfilter(c)
	return c:IsSetCard(0x514a) and c:IsFaceup()
end
function c24100.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c24100.sprfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,tp)
		and not (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and not Duel.IsExistingMatchingCard(c24100.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp))
end
function c24100.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c24100.sprfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c24100.sprfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoGrave(g1,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c24100.sprfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c24100.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO 
	and (Duel.GetTurnPlayer()~=tp or Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==PHASE_STANDBY or Duel.GetCurrentPhase()==PHASE_MAIN1)
end
function c24100.spfilter(c,e,tp)
	return c:IsSetCard(0x625) and c:GetLevel()<=5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c24100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24100.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c24100.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24100.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	
	end
end
function c24100.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c24100.dop(e,tp,eg,ep,ev,re,r,rp)
	--cannot act
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c24100.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--direct attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c24100.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c24100.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return e:GetHandler()==te:GetHandler()
end