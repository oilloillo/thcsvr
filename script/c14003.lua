 --梦幻馆的吸血少女 胡桃
function c14003.initial_effect(c)
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c14003.target)
	e1:SetOperation(c14003.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14003,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c14003.spcon)
	e2:SetTarget(c14003.sptg)
	e2:SetOperation(c14003.spop)
	c:RegisterEffect(e2)
end
function c14003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=0
	local c=e:GetHandler()
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToDeck() and Duel.CheckLPCost(tp,400)
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(14003,1),aux.Stringid(14003,2))+1
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(14003,1))+1
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(14003,2))+2
	end
	e:SetLabel(opt)
	if opt==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	elseif opt==2 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
		Duel.PayLPCost(tp,400)
	else
		e:SetCategory(0)
	end
end
function c14003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if c:IsRelateToEffect(e) then
			e:GetHandler():RegisterFlagEffect(14003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	elseif e:GetLabel()==2 then
		if c:IsRelateToEffect(e) then
			Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
		end
	end
end
function c14003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(14003)~=0
end
function c14003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(140030)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(140030,RESET_PHASE+PHASE_END,0,1)
end
function c14003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
	end
end
