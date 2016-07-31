 
--冬天的遗忘物
function c20001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20001.spcon)
	e1:SetOperation(c20001.spop)
	c:RegisterEffect(e1)
	--self destroy
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20001,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20001.tdcon)
	e2:SetTarget(c20001.tdtg)
	e2:SetOperation(c20001.tdop)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20001,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c20001.condition)
	e3:SetTarget(c20001.target)
	e3:SetOperation(c20001.operation)
	c:RegisterEffect(e3)
end
function c20001.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c20001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(c:GetControler(),20001)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c20001.filter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function c20001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,20001,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(c20001.synlimit)
	e:GetHandler():RegisterEffect(e1,true)
end
function c20001.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x999)
end
function c20001.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c20001.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c20001.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c20001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20001.thfilter(c)
	return c:IsCode(22009) and c:IsAbleToHand()
end
function c20001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c20001.thfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
